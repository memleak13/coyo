
function qfilter(id)
{
	var input = document.forms[id];
	var prefix = "";
	var result = "";
	for (i=0; i<input.length; ++i) {
		var e = input[i];
		switch (e.type) {
			case "text":
			case "hidden":
			case "select-one":
				result += prefix + e.name + "=" + e.value;
				break;
		}
		prefix = "&";
	}
	return(result);
}

function populateLocationFields(chassis, slot, port, butype) {
	input.chassis.value = chassis;
	input.slot.value = slot;
	input.port.value = port;
	input.butype.value = butype;
}

function md5encode(id)
{
	var e = document.getElementById(id);
	if (e) {
		e.value = hex_md5(e.value);
	}
}
function ajaxCreateObject()
{
        if (self.XMLHttpRequest)
        	return(new XMLHttpRequest());
        return(new ActiveXObject("Microsoft.XMLHTTP"));
}

function ajaxCreateDocument(tag)
{
    if (document.implementation && document.implementation.createDocument)
        return(document.implementation.createDocument(null, tag, null));
    dom=new ActiveXObject("Msxml.DOMDocument");
    root  = dom.createElement(tag);
    dom.appendChild(root)
    return dom;
}


function ajaxCreate(url, formID)
{
	try {

		ajaxDisable("ajaxCreateButton");
		ajaxSetClass("ajaxCreateError", "ajaxHidden");
		ajaxSpinnerShow("ajaxCreateSpinner");

		var http = ajaxCreateObject();
        
		http.open("POST", url, true);
        
		http.onreadystatechange = function () {
			if (this.readyState == 4) {
				if (this.status == 200) {
					window.location.href = window.location.href;
					return;
				}
				ajaxSpinnerHide("ajaxCreateSpinner");
				ajaxSetClass("ajaxCreateError", "ajaxError");
				ajaxEnable("ajaxCreateButton");
                alert( "Error " + this.status + "\n" + this.responseText );
			}
		};
        
		//var doc = document.implementation.createDocument(null, "create", null);
        var doc = ajaxCreateDocument("create");
        
		var root = doc.documentElement;
		var input = document.forms[formID];
        
		for (i=0; i<input.length; ++i) {
			var e = input[i];
			switch (e.type) {
				case "text":
				case "hidden":
				case "select-one":
					root.setAttribute(e.name, e.value);
					break;
				case "checkbox":
					root.setAttribute(e.name, e.checked ? "yes" : "no");
					break;
			}
		}
		http.send(doc);

	} catch (x) {
		alert(x.description);
	}
}

function ajaxUpdate(url, formID, next)
{
	try {

		ajaxDisable("ajaxUpdateButton");
		ajaxSetClass("ajaxUpdateError", "ajaxHidden");
		ajaxSpinnerShow("ajaxUpdateSpinner");

		var http = ajaxCreateObject();

		http.open("POST", url, true);

		http.onreadystatechange = function () {
			if (this.readyState == 4) {
				if (this.status == 200) {
					window.location.href = next;
					return;
				}
				ajaxSpinnerHide("ajaxUpdateSpinner");
				ajaxSetClass("ajaxUpdateError", "ajaxError");
				ajaxEnable("ajaxUpdateButton");
                alert( "Error " + this.status + "\n" + this.responseText );
			}
		};

        var doc = ajaxCreateDocument("update");
		var root = doc.documentElement;
		var input = document.forms[formID];
		for (i=0; i<input.length; ++i) {
			var e = input[i];
			switch (e.type) {
				case "text":
				case "hidden":
				case "textarea":
				case "select-one":
					root.setAttribute(e.name, e.value);
					break;
				case "checkbox":
					root.setAttribute(e.name, e.checked ? "yes" : "no");
					break;
			}
		}
		
		http.send(doc);

	} catch (x) {
		alert(x.description);
	}
}

function ajaxDelete(url, itemname)
{
	try {

		Check = confirm("Do you really want to delete the " + itemname + "?");
		if (Check == false)
			return;    
    
		ajaxDisable("ajaxDeleteButton");
		ajaxSetClass("ajaxDeleteError", "ajaxHidden");
		ajaxSpinnerShow("ajaxDeleteSpinner");
		
		var http = ajaxCreateObject();
		http.open("DELETE", url, true);

		http.onreadystatechange = function () {
			if (this.readyState == 4) {
                if (this.status == 200) {
					window.location.href = window.location.href;
					return;
				}
				ajaxSpinnerHide("ajaxDeleteSpinner");
				ajaxSetClass("ajaxDeleteError", "ajaxError");
				ajaxEnable("ajaxDeleteButton");
                alert( "Error " + this.status + "\n" + this.responseText );
			}
		};
		http.send("");

	} catch (x) {
        alert(x.description);
	}
}

function ajaxTrigger(url)
{
	try {

		ajaxDisable("ajaxTriggerButton");

		var http = ajaxCreateObject();

		http.open("POST", url, true);

		http.onreadystatechange = function () {
			if (this.readyState == 4) {
				if (this.status == 200) {
					window.location.href = window.location.href;
					return;
				}
				ajaxEnable("ajaxTriggerButton");
			}
		};

		http.send("+");

	} catch (x) {
		alert(x.description);
	}
}

function ajaxEnable(id)
{
	var e = document.getElementById(id);
	if (e)
		e.disabled = false;
}

function ajaxDisable(id)
{
	var e = document.getElementById(id);
	if (e)
		e.disabled = true;
}

function ajaxSetClass(id, className)
{
	var e = document.getElementById(id);
	if (e) {
		e.className = className;
	}
}

function ajaxSpinnerShow(id)
{
	var e = document.getElementById(id);
	if (e) {
		e.className = "ajaxError";
        e.style.backgroundRepeat = "no-repeat";
        e.style.backgroundImage = "url(/resource/spinner.gif)";
	}
}

function ajaxSpinnerHide(id)
{
	var e = document.getElementById(id);
	if (e) {
		e.className = "ajaxHidden";
		e.style.backgroundImage = "";
	}
}
