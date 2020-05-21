declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: This function shows the tei head :)
declare function local:applyTemplateHead($nodes as node()*) as node()* {
    <h1>
        {
            for $node in $nodes
            return
                local:applyTemplates($node)
        }
    </h1>
};

declare function local:applyTemplateHi($nodes as node()*) as node()* {
    for $node in $nodes
    return
        if ($node/@rend = "u") then
            (
            <u>{local:applyTemplates($node/node())}</u>
            )
        else
            (
            <sup>{local:applyTemplates($node/node())}</sup>
            )
};

declare function local:applyTemplateP($nodes as node()*) as node()* {
    for $node in $nodes
    return
        <p>{local:applyTemplates($node/node())}</p>
};

declare function local:applyTemplateDel($nodes as node()*) as node()* {
    for $node in $nodes
    return
        <s>{local:applyTemplates($node/node())}</s>
};

declare function local:applyTemplateAdd($nodes as node()*) as node()* {
    for $node in $nodes
    return
        if ($node/@place = "marginleft") then
            (
            <span
                style="left:-5em; position: absolute; font-size: 0.6em;">
                {local:applyTemplates($node/node())}
            </span>
            )
        else
            (
            <s>{local:applyTemplates($node/node())}</s>
            )
};

declare function local:applyTemplateLb($nodes as node()*) as node()* {
    <br/>
};

declare function local:applyTemplates($nodes as node()*) as node()* {
    for $node in $nodes
    return
        typeswitch ($node)
            case element(tei:hi)
                return
                    local:applyTemplateHi($node)
            case element(tei:p)
                return
                    local:applyTemplateP($node)
            case element(tei:del)
                return
                    local:applyTemplateDel($node)
            case element(tei:add)
                return
                    local:applyTemplateAdd($node)
            case element(tei:lb)
                return
                    local:applyTemplateLb($node)
            default
                return
                    $node
};

declare function local:countHands($node as node()) {
    count($node//*[@hand])
};

let $root := doc("Frankenstein-osd.xml")/tei:TEI
return
    (
    <html>
        <head>
            <link
                rel="stylesheet"
                href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"/>
            <meta
                charset="UTF-8"/>
        </head>
        <body>
            <div
                class="container">
                <div
                    class="row">
                    <div
                        class="col-sm">
                        <div id="openseadragon" style="width: 400px; height: 600px;">Loading...</div>
                        {
                            let $graphicUrl := $root//tei:facsimile/tei:graphic/@url/data()
                            return
                              <script type="text/javascript">
                                const script = document.createElement("script");
                                script.src = "http://cdn.jsdelivr.net/npm/openseadragon@2.4/build/openseadragon/openseadragon.min.js";
                                document.body.appendChild(script);
            
                                script.onload = function() {{
                                    document.getElementById("openseadragon").textContent = "";
                                    var viewer = OpenSeadragon({{
                                    id: "openseadragon",
                                    prefixUrl: "https://cdn.jsdelivr.net/npm/openseadragon@2.4/build/openseadragon/images/",
                                    tileSources:   [{{
                                    "@context": "http://iiif.io/api/image/2/context.json",
                                    "@id": "{$graphicUrl}",
                                    "height": 8176,
                                    "width": 6128,
                                    "profile": [ "http://iiif.io/api/image/2/level2.json" ],
                                    "protocol": "http://iiif.io/api/image",
                                    "tiles": [{{
                                    "scaleFactors": [ 1, 2, 4, 8, 16, 32 ],
                                    "width": 1024
                                    }}]
                                    }}]
                                    }});
                                }}
                            </script>
                        }
                        </div>
                    <div
                        class="col-sm"
                        style="margin-left: 5em">
                        {
                            let $teiHead := $root//tei:head
                            return
                                local:applyTemplateHead($teiHead/node())
                        }
                        
                        {
                            let $teiP := $root//tei:div//tei:p
                            return
                                local:applyTemplateP($teiP)
                        }
                        
                        Corrections: {local:countHands($root)}
                    </div>
                </div>
            </div>
        </body>
    </html>
    )
