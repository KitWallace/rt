import module namespace config = "http://kitwallace.me/rtconfig" at "/db/apps/rt/lib/config.xqm";

let $id := request:get-parameter("_id","")
let $pin := request:get-parameter("_pin","")
where $pin = $config:pin
return
let $doc := doc(concat($config:streams,$id,".xml"))/stream
let $params := request:get-parameter-names()
let $data :=
   element data {
     attribute ts {current-dateTime()},
     for $p in $params
     where not(starts-with($p,"_"))
     return
       element {$p} {request:get-parameter($p,"")}
    }  
let $update := update insert $data into $doc
return 
<result>
  {$update}
  {$data}
</result>
