/* 
Copyright (c) 2012 Matthias S. Benkmann

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, 
MA  02110-1301, USA.
*/

package message

import (
         "fmt"
         "time"
         "regexp"
         "strings"
         
         "../db"
         "../xml"
         "../util"
         "../config"
       )

const re_1xx = "(1([0-9]?[0-9]?))"
const re_2xx = "(2([6-9]|([0-4][0-9]?)|(5[0-5]?))?)"
const re_xx  = "([3-9][0-9]?)"
const re_port = "(0|([1-6][0-9]{0,4})|([7-9][0-9]{0,3}))"
const ip_part = "(0|"+re_1xx+"|"+re_2xx+"|"+re_xx+")"
var addressRegexp = regexp.MustCompile("^"+ip_part+"([.]"+ip_part+"){3}:"+re_port+"$")

// Handles the message "foreign_job_updates".
//  xmlmsg: the decrypted and parsed message.
// Returns:
//  unencrypted reply
func foreign_job_updates(xmlmsg *xml.Hash) string {
  source := xmlmsg.Text("source")
  
  if !addressRegexp.MatchString(source) {
    // We could try name lookup here, but non-numeric <source> fields
    // don't occur in the wild. So we just bail out with a message.
    util.Log(0, "ERROR! <source>%v</source> is not in IP:PORT format", source)
    return ErrorReply(fmt.Sprintf("%v is not in IP:PORT format", source))
  }
  
  for _, tag := range xmlmsg.Subtags() {
  
    if !strings.HasPrefix(tag, "answer") { continue }
  
    for answer := xmlmsg.First(tag); answer != nil; answer = answer.Next() {
      job := answer.Clone()
      job.Rename("job")
      
      if job.Text("siserver") == "localhost" {
        job.First("siserver").SetText(source)
      }
      siserver := job.Text("siserver")
      
      xmlmess := job.First("xmlmessage")
      if xmlmess == nil {
        util.Log(0, "ERROR! <xmlmessage> missing from job descriptor")
        // go-susi doesn't need xmlmessage. We just add an empty one.
        // It would be nicer to generate a proper xmlmessage from the
        // job, but I'm too lazy to code this right now. This case doesn't
        // occur in the wild.
        job.Add("xmlmessage","") 
      } else 
      {
        // remove all whitespace from xmlmessage
        // This works around gosa-si's behaviour of introducing whitespace
        // which breaks base64 decoding.
        xmlmess.SetText(strings.Join(strings.Fields(xmlmess.Text()),""))
      }
      
      if !addressRegexp.MatchString(siserver) {
        // We could try name lookup here, but non-numeric <siserver> fields
        // don't occur in the wild. So we just bail out with a message.
        util.Log(0, "ERROR! <siserver>%v</siserver> is not in IP:PORT format", siserver)
        return ErrorReply(fmt.Sprintf("%v is not in IP:PORT format", siserver))
      }
      
      status := strings.ToLower(job.Text("status"))
      job.FirstOrAdd("status").SetText(status)
      headertag := strings.ToLower(job.Text("headertag"))
      job.FirstOrAdd("headertag").SetText(headertag)
      macaddress := strings.ToLower(job.Text("macaddress"))
      job.FirstOrAdd("macaddress").SetText(macaddress)
      
      // If the update targets a local job, it must be translated to a delete or modify
      if siserver == config.ServerSourceAddress {
        // The <id> field is the id of the job in the sending server's database
        // which is not meaningful to us. So the best we can do is select all
        // local jobs which match the headertag/macaddress combination.
        filter := xml.FilterSimple("siserver", config.ServerSourceAddress, "headertag",headertag,"macaddress",macaddress)
        
        if status == "done" { // remove local job
          
          db.JobsRemoveLocal(filter)
          
        } else // modify local job
        {
          db.JobsModifyLocal(filter, job)
        }
      } else if siserver == source { // the job belongs to the sender
          // Because the job belongs to the sender, the <id> field corresponds to
          // the <original_id> we have in our database, so we can select the
          // job with precision.
          filter := xml.FilterSimple("original_id", job.Text("id"))
          
        if status == "done" { // remove foreign job
          
          db.JobsRemoveForeign(filter)
          
        } else // modify existing or add new foreign job
        {
          db.JobsAddOrModifyForeign(filter, job)
        }
          
      } else { // the job belongs to a 3rd party peer
        // We don't trust Chinese whispers, so we don't use the job information
        // directly. Instead we schedule a query of the affected 3rd party's
        // jobdb. This needs to be done with a delay, because the 3rd party
        // may not even have received the foreign_job_updates affecting its job.
        go util.WithPanicHandler(func() {
          time.Sleep(5*time.Second) // 5s should be enough, even for gosa-si
          // PeerConnectionManager.GetConnection(siserver).GetAllLocalJobsFromPeer()
        })
      }
    
    }
  }
  
  return ""
}
