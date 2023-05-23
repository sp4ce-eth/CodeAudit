

<html>
    <head>
        <title>Nintex Forms for Office 365</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <script type="text/javascript">
            (function () {

                window.addEventListener("message", setNintexFormO365Cookie, false);

                function setNintexFormO365Cookie(event) {

                    if (event.data === "NintexFormO365 not set") {
                        var remoteAppUrl = getParameterByName("remoteAppUrl");
                        var isRedirecting = getParameterByName("Nfo.IsRedirectingToRegionalInstance");
                        var redirectUri = getParameterByName("redirectUri");


                        // 34929: If we are redirecting to regional instance set the remoteAppUrl to redirectUri.
                        // May be able to remove this check
                        if (isRedirecting === "1" && redirectUri) {
                            remoteAppUrl = redirectUri;
                        }

                        document.location.href = remoteAppUrl + "/Pages/NFLaunchForms.aspx";
                    }
                }

                function loadFormFillerframe() {

                    // Automatically generated. DO NO UPDATE OR DELETE.
                    //{Start-Clientid} 
                    var clientid = '73d49b7f-c0a4-4891-b2bb-65f7f7142c79';
                    //{End-Clientid}

                    var originalUrl = document.location.toString();
                    var remoteAppUrl = getParameterByName("remoteAppUrl");
                    var isRedirecting = getParameterByName("Nfo.IsRedirectingToRegionalInstance");
                    var redirectUri = getParameterByName("redirectUri");
                   

                    // 34929: If we are redirecting to regional instance set the remoteAppUrl to redirectUri.
                    if (isRedirecting === "1" && redirectUri) {
                        remoteAppUrl = redirectUri;
                    }

                    var querystringposition = originalUrl.indexOf('?');
                    var url = remoteAppUrl + '/Pages/FormsPart.aspx';
                    var appWebUrl = getAppWebUrl();

                    var frame;
                    var querystring = '';
                    if (querystringposition > 0) {
                        querystring = originalUrl.substr(querystringposition);
                    }

                    querystring = querystring.replace(/amp;/g, '');
                    if (appWebUrl.length > 1) {
                        querystring = replaceQueryString(querystring, "SPAppWebUrl", appWebUrl);
                    }

                    // 34929 - Remove the query string parameter from the url so it will redirect to reigonal instance.
                    if (isRedirecting === "1") {
                        querystring = removeURLParameter(querystring, "Nfo.IsRedirectingToRegionalInstance");
                    }

                    document.body.style.margin = 0;
                    document.body.style.overflow = "auto";

                    frame = document.getElementsByTagName('iframe')[0];
                    frame.frameBorder = 0;
                    frame.style.border = 0;
                    frame.style.width = '100%';
                    frame.style.height = '100%';
                    frame.style.position = 'absolute';
                    frame.style.top = 0;
                    frame.style.left = 0;
                    frame.style.right = 0;
                    frame.style.bottom = 0;
                    frame.target = "_top";
                    frame.allow = "geolocation *; microphone *; camera *; midi *; encrypted-media *";
                    
                    frame.src = '_layouts/15/appredirect.aspx?client_id=' + clientid + '&redirect_uri=' + encodeURIComponent(url + querystring);
                }

                function loadSpPageframe() {
                    var self = this;
                    var frame = document.getElementsByTagName('iframe')[0];

                    self.getQueryStringParamByName = function (name) {
                        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
                        var regexS = "[\\?&]" + name + "=([^&#]*)";
                        var regex = new RegExp(regexS);
                        var results = regex.exec(document.location.toString());
                        if (results == null)
                            return "";
                        else
                            return decodeURIComponent(results[1].replace(/\+/g, " "));
                    };

                    //when the iframe is loaded then we need to resize it and give it an overflow.
                    self.iframeLoaded = function () {
                        //var frame1 = document.getElementsByTagName('iframe')[0];
                        var frameDocument = frame.contentDocument || frame.contentWindow.document;

                        var frameContent = frameDocument.getElementById("s4-workspace");
                        //bug: 68221 - prevent consol error 
                        if (frameContent != null) {
                            frameContent.style.height = '650px';
                            frameContent.style.overflowY = 'auto';
                        }
                    };

                    var url = self.getQueryStringParamByName("Url");
                    var redirectUrl = self.getQueryStringParamByName("redirectUrl");
                    var scriptsPath = url.substring(0, url.indexOf('/_layouts')) + "/_layouts/15/";

                    frame.frameBorder = 0;
                    frame.style.border = 0;
                    frame.style.width = '100%';
                    frame.style.height = '100%';
                    frame.style.position = 'fixed';
                    frame.style.top = 0;
                    frame.style.left = 0;
                    frame.style.right = 0;
                    frame.style.bottom = 0;
                    frame.src = url;

                    if (frame.addEventListener)
                        frame.addEventListener('load', self.iframeLoaded, true);
                    else if (frame.attachEvent)
                        frame.attachEvent('onload', self.iframeLoaded);

                    if (frame.cancelPopUp == undefined) {
                        frame.cancelPopUp = function () {
                            self.cancelPopUp();
                        };
                    }

                    if (frame.commitPopup == undefined) {
                        frame.commitPopup = function (e) {
                            self.commitPopup(e);
                        };
                    }

                    //callback function from sharepoint page when user click cancel.
                    self.cancelPopUp = function () {
                        var param = "?action=closeDialog&locationUrl=" + redirectUrl;
                        window.location.href = redirectUrl + param;
                    };

                    //callback function from sharepoint page when user click save.
                    self.commitPopup = function (e) {
                        var param = "?action=CreateColumnSuccess&locationUrl=" + redirectUrl;
                        window.location.href = redirectUrl + param;
                    };


                }

                function getAppWebUrl() {
                    var documentLocation = document.location.toString();
                    var appWeb = '';
                    if (documentLocation.indexOf("/FormsApp") > 0) {
                        appWeb = documentLocation.substring(0, documentLocation.indexOf("/FormsApp")) + "/FormsApp";
                    }
                    return appWeb;
                }

                function replaceQueryString(url, param, value) {
                    var re = new RegExp("([?|&])" + param + "=.*?(&|$)", "i");
                    if (url.match(re))
                        return url.replace(re, '$1' + param + "=" + value + '$2');
                    else
                        return url + '&' + param + "=" + value;
                }

                function getParameterByName(name) {
                    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
                    var regexS = "[\\?&]" + name + "=([^&#]*)";
                    var regex = new RegExp(regexS);
                    var decodedUrl = decodeURIComponent(document.location.toString()).replace(/amp;/g, '');
                    var results = regex.exec(decodedUrl);
                    if (results == null)
                        return "";
                    else
                        return decodeURIComponent(results[1].replace(/\+/g, " "));
                }

                function closeParentDialog(refresh) {
                    var target = parent.postMessage ? parent : (parent.document.postMessage ? parent.document : undefined);
                    if (refresh) {
                        console.log('CloseCustomActionDialogRefresh true - ');
                        target.postMessage('CloseDialog', '*');
                    }
                    else {
                        target.postMessage('CloseDialog', '*');
                    }
                }

                function removeURLParameter(url, parameter) {
                    var urlparts = url.split('?');
                    if (urlparts.length >= 2) {

                        var prefix = encodeURIComponent(parameter) + '=';
                        var pars = urlparts[1].split(/[&;]/g);

                        //reverse iteration as may be destructive
                        for (var i = pars.length; i-- > 0;) {
                            //idiom for string.startsWith
                            if (pars[i].lastIndexOf(prefix, 0) !== -1) {
                                pars.splice(i, 1);
                            }
                        }

                        url = urlparts[0] + '?' + pars.join('&');
                        return url;
                    } else {
                        return url;
                    }
                }

                window.onload = function () {
                    // we need this so all browser can open new window
                    var remoteAppUrl = getParameterByName("remoteAppUrl");
                    var loadSpPageUrl = getParameterByName("Url");

                    if (loadSpPageUrl && loadSpPageUrl != "") {
                        loadSpPageframe();
                    } else {
                        var onmessage = function (e) {

                            //check if coming from a known source
                            if (e.origin == remoteAppUrl) {
                                var target = parent.postMessage ? parent : (parent.document.postMessage ? parent.document : undefined);

                                target.postMessage(e.data, '*');
                            }
                        };

                        if (typeof window.addEventListener != 'undefined') {
                            window.addEventListener('message', onmessage, false);
                        } else if (typeof window.attachEvent != 'undefined') {
                            window.attachEvent('onmessage', onmessage);
                        }

                        loadFormFillerframe();
                    }
                };
            })();

        </script>
    </head>
    <body style="margin: 0px; padding: 0px;">
        <script type='text/javascript'>
                var spAppIFrameSenderInfo = new Array(1);
                var SPAppIFramePostMsgHandler = function(e)
                {
                    if (e.data.length > 100)
                        return;

                    var regex = RegExp(/(<\s*[Mm]essage\s+[Ss]ender[Ii]d\s*=\s*([\dAaBbCcDdEdFf]{8})(\d{1,3})\s*>[Rr]esize\s*\(\s*(\s*(\d*)\s*([^,\)\s\d]*)\s*,\s*(\d*)\s*([^,\)\s\d]*))?\s*\)\s*<\/\s*[Mm]essage\s*>)/);
                    var results = regex.exec(e.data);
                    if (results == null)
                        return;

                    var senderIndex = results[3];
                    if (senderIndex >= spAppIFrameSenderInfo.length)
                        return;

                    var senderId = results[2] + senderIndex;
                    var iframeId = unescape(spAppIFrameSenderInfo[senderIndex][1]);
                    var senderOrigin = unescape(spAppIFrameSenderInfo[senderIndex][2]);
                    if (senderId != spAppIFrameSenderInfo[senderIndex][0] || senderOrigin != e.origin)
                        return;

                    var width = results[5];
                    var height = results[7];
                    if (width == "")
                    {
                        width = '300px';
                    }
                    else
                    {
                        var widthUnit = results[6];
                        if (widthUnit == "")
                            widthUnit = 'px';
                    
                        width = width + widthUnit;
                    }

                    if (height == "")
                    {
                        height = '150px';
                    }
                    else
                    {
                        var heightUnit = results[8];                        
                        if (heightUnit == "")
                            heightUnit = 'px';

                        height = height + heightUnit;
                    }
                    
                    var widthCssText = "";
                    var resizeWidth = ('False' == spAppIFrameSenderInfo[senderIndex][3]);
                    if (resizeWidth)
                    {
                        widthCssText = 'width:' + width + ' !important;';
                    }
                    
                    var cssText = widthCssText;
                    var resizeHeight = ('False' == spAppIFrameSenderInfo[senderIndex][4]);
                    if (resizeHeight)
                    {
                        cssText += 'height:' + height + ' !important';
                    }

                    if (cssText != "")
                    {
                        var webPartInnermostDivId = spAppIFrameSenderInfo[senderIndex][5];
                        if (webPartInnermostDivId != "")
                        {
                            var webPartDivId = 'WebPart' + webPartInnermostDivId;

                            var webPartDiv = document.getElementById(webPartDivId);
                            if (null != webPartDiv)
                            {
                                webPartDiv.style.cssText = cssText;
                            }
                            
                            cssText = "";
                            if (resizeWidth)
                            {
                                var webPartChromeTitle = document.getElementById(webPartDivId + '_ChromeTitle');
                                if (null != webPartChromeTitle)
                                {
                                    webPartChromeTitle.style.cssText = widthCssText;
                                }
                                
                                cssText = 'width:100% !important;'
                            }

                            if (resizeHeight)
                            {
                                cssText += 'height:100% !important';
                            }
                            
                            var webPartInnermostDiv = document.getElementById(webPartInnermostDivId);
                            if (null != webPartInnermostDiv)
                            {
                                webPartInnermostDiv.style.cssText = cssText;
                            }
                        }

                        var iframe = document.getElementById(iframeId);
                        if (null != iframe)
                        {
                            iframe.style.cssText = cssText;
                        }
                    }
                }

                if (typeof window.addEventListener != 'undefined')
                {
                    window.addEventListener('message', SPAppIFramePostMsgHandler, false);
                }
                else if (typeof window.attachEvent != 'undefined')
                {
                    window.attachEvent('onmessage', SPAppIFramePostMsgHandler);
                }spAppIFrameSenderInfo[0] = new Array("9AB8C48A0","SPAppIFrame1","","False","False","");
</script><iframe id="SPAppIFrame1" frameborder="0"></iframe>
    </body>
</html>
<script type="text/javascript" nonce="f8f234b9-fa76-4180-a8c6-13f384e06e40">
	var g_duration = 60;
var g_iisLatency = 0;
var g_cpuDuration = 34;
var g_queryCount = 5;
var g_queryDuration = 10;
var g_requireJSDone = new Date().getTime();
</script>
