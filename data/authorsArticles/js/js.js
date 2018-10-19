
function confirmDelete() {
    return confirm("هل انت متأكد من متابعة عملية الحذف؟");

}

function mustSelect() {
    alert("لا بد من إختيار الكتاب المطلوب حذفهم أولاً!.");
}

function printContent(wrap) {
    var myWindow = window.open("", "PrintContentWindow", "resizable,scrollbars,fullscreen");
    var windowHTML = "<html><head><link rel='Shortcut Icon' href='css/sakhr.png' /> <link href='css/printing.css' rel='stylesheet' type='text/css' /><link type='text/css' rel='stylesheet' href='css/jquery.galleryview-3.0-dev.css' /><link type='text/css' rel='stylesheet' href='css/jquery.galleryview-3.0-dev-slider.css' /><link type='text/css' rel='stylesheet' href='css/jquery.galleryview-3.0-dev-panning.css' /><title>PrintingPage</title></head><body><div id='wrap'>";
    myWindow.document.write(windowHTML + wrap + "</div></body></html>");
    myWindow.print();
    myWindow.document.close();
    return false;
}


function savePage() {
    if (navigator.appName != "Microsoft Internet Explorer")
        alert("Please press Ctrl+D to save the page.");
    else
        document.execCommand("SaveAs");

}


function ValidateFile(source, args) {
    try {
        var fileAndPath =
           document.getElementById(source.controltovalidate).value;
        var lastPathDelimiter = fileAndPath.lastIndexOf("\\");
        var fileNameOnly = fileAndPath.substring(lastPathDelimiter + 1);
        var file_extDelimiter = fileNameOnly.lastIndexOf(".");
        var file_ext = fileNameOnly.substring(file_extDelimiter + 1).toLowerCase();
        if (file_ext != "jpg") {
            if (file_ext != "gif")
                if (file_ext != "png")
                    args.IsValid = false;
    }
    else
        args.IsValid = true;
    return;
}
catch (err) {
    txt = "There was an error on this page.\n\n";
    txt += "Error description: " + err.description + "\n\n";
    txt += "Click OK to continue.\n\n";
    txt += document.getElementById(source.controltovalidate).value;
    alert(txt);
}

args.IsValid = true;
}

function ValidateTxtFile(source, args) {
    try {
        var fileAndPath =
           document.getElementById(source.controltovalidate).value;
        var lastPathDelimiter = fileAndPath.lastIndexOf("\\");
        var fileNameOnly = fileAndPath.substring(lastPathDelimiter + 1);
        var file_extDelimiter = fileNameOnly.lastIndexOf(".");
        var file_ext = fileNameOnly.substring(file_extDelimiter + 1).toLowerCase();
        if (file_ext != "txt") {
            if (file_ext != "doc")
                if (file_ext != "docx")
                    args.IsValid = false;
    }
    else
        args.IsValid = true;
    return;
}
catch (err) {
    txt = "There was an error on this page.\n\n";
    txt += "Error description: " + err.description + "\n\n";
    txt += "Click OK to continue.\n\n";
    txt += document.getElementById(source.controltovalidate).value;
    alert(txt);
}

args.IsValid = true;
}

function selectStyleSheet(cssId) {
   // alert("Platform Name: "+navigator.platform + ".\nBrowser Name: " + navigator.appName);
   /* if (navigator.platform=="iPad") {
                document.getElementById(cssId).setAttribute("href", "css/Tablet-style.css");
     //   document.getElementById(cssId).setAttribute("href", "css/style.css");
      // alert("iPad");
    }
    else */if (navigator.appName != "Microsoft Internet Explorer") {
        if (navigator.appName == "Opera") {
            document.getElementById(cssId).setAttribute("href", "css/style_O.css");
        }
        else {
            document.getElementById(cssId).setAttribute("href", "css/style.css");
        }


    }
    else {
        var IEVersion = checkIEVersion();
        //alert(IEVersion);
        if (IEVersion == "8") {
            //alert(IEVersion);
            document.getElementById(cssId).setAttribute("href", "css/style.css");
        }
        else if (IEVersion == "7") {
//            alert(IEVersion);
//            document.getElementById(cssId).setAttribute("href", "css/style_IE7.css");
//            document.getElementById(cssId).setAttribute("href", "css/style.css");
            document.getElementById(cssId).setAttribute("href", "css/style_IE7_2013.css");
            //document.getElementById(cssId).setAttribute("href", "css/style.css");
        }
        else if (IEVersion == "6") {
            alert("Sorry, You Must Upgrade your browser.");
        }

    }
    return;
}

function getInternetExplorerVersion()
// Returns the version of Windows Internet Explorer or a -1
// (indicating the use of another browser).
{
    var rv = -1; // Return value assumes failure.
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    return rv;
}

function checkIEVersion() {
    var msg = "You're not using Windows Internet Explorer.";
    var ver = getInternetExplorerVersion();
    if (ver > -1) {
        if (ver >= 8.0)
            msg = "8";
        else if (ver == 7.0)
            msg = "7";
        else if (ver == 6.0)
            msg = "6";
        else
            msg = "You should upgrade your copy of Windows Internet Explorer";
    }
    return msg;
}

