declare namespace tei="http://www.tei-c.org/ns/1.0"; 

declare function local:countHands($node as node()) {
    count($node//*[@hand])
};

declare function local:applyTemplateHead($node as node()) as node()* {
    <h1>{local:applyTemplates($node/node())}</h1>
};


declare function local:applyTemplates($nodes as node()*) as node()* {
    for $node in $nodes
    return
        typeswitch ($node)
            case element(tei:head)
                return
                    local:applyTemplateHead($node)
            case element()
                 return local:applyTemplates($node/node())
            default
                return $node
};

let $root := doc("Frankenstein-v1c5-transcription.xml")

return <html>
            <head>
             <link
                rel="stylesheet"
                href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"/>
            <meta
                charset="UTF-8"/>
            </head>
             <body><div
                class="container">
                <div
                    class="row">
                    <div
                        class="col-sm">
                        {
                            let $graphicUrl := $root//tei:facsimile/tei:graphic/@url
                            return
                                <img
                                    width="600"
                                    src="{$graphicUrl}"/>
                        }
                    </div>
                    <div
                        class="col-sm"
                        style="margin-left: 5em">
                        {
                            let $teiHead := $root//tei:head
                            return local:applyTemplates($teiHead)
                        }
                        
                        
                        Corrections: {local:countHands($root)}
                    </div>
                </div>
            </div>
             </body>
       </html>

