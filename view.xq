import module namespace config = "http://kitwallace.me/rtconfig" at "/db/apps/rt/lib/config.xqm";

let $id := request:get-parameter("_id","")

return
let $doc := doc(concat("/db/apps/rt/streams/",$id,".xml"))/stream
let $action := request:get-parameter("_action","")
let $result :=
       if ($action="last" and exists($doc))
       then let $n := number(request:get-parameter("n",50))
            let $last := count($doc/data)
            let $start := max(($last - $n,1))
            return
             <data start="{$start}" end="{$last}">
               {$doc/data[position()>=$start]}
             </data>
             
        else <message>no action</message>
return
    $result