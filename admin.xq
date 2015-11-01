import module namespace config = "http://kitwallace.me/rtconfig" at "/db/apps/rt/lib/config.xqm";

let $id := request:get-parameter("_id","")
let $pin := request:get-parameter("_pin","")
where $pin = $config:pin
return
let $doc := doc(concat("/db/apps/rt/streams/",$id,".xml"))/stream
let $action := request:get-parameter("_action","")
let $result :=
  if ($action= "create")
  then if (exists($doc))
       then <message>stream already exists</message>
       else 
          let $doc := <stream id="{$id}" createdOn="{current-dateTime()}"></stream>
          let $store := xmldb:store("/db/apps/rt/streams/",concat($id,".xml"),$doc)
          return <message>stream {$id} created</message> 
          
  else if ($action="clear" and exists($doc))
       then 
          let $doc := <stream id="{$id}" createdOn="{current-dateTime()}"></stream>
          let $store := xmldb:store("/db/apps/rt/streams/",concat($id,".xml"),$doc)
          return <message>stream {$id} cleared</message> 

  
             
  else <message>no action</message>
  return
    $result
