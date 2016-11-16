

function removeElementsByClassName(aClassName) {
	liste=document.getElementsByClassName(aClassName);
	while (liste.length>0) {
		//console.log(liste[0]);
		liste[0].parentNode.removeChild(liste[0]);
	};
}
function moveAtEndElementsByClassName(aClassName) {
	//console.log("la classe cherchee:"+aClassName);
	eltsSelected=document.getElementsByClassName(aClassName);
	a=eltsSelected.length;
	//console.log("Taille de la liste trouvee:"+a);
	for (i=0;i<a;i++){
		var item = eltsSelected[i];
		//console.log("Item traité:"+item);
		var parentItem=item.parentNode;
		//console.log("Item traité:"+parentItem);
		parentItem.removeChild(item);
		//console.log ("element retiré");
		parentItem.appendChild(item);
	}
}
function addingABr(aClassName) {
	//console.log("la classe cherchee:"+aClassName);
	eltsSelected=document.getElementsByClassName(aClassName);
	a=eltsSelected.length;
	//console.log("Taille de la liste trouvee:"+a);
	for (i=0;i<a;i++){
		var item = eltsSelected[i];
		//console.log("Item traité:"+item);
		var parentItem=item.parentNode;
		//console.log("Item traité:"+parentItem);
		var aBr = document.createElement("BR");
		aBr.className="noColumnBreakAfter";
		//console.log ("element retiré");
		parentItem.insertBefore(aBr,item);
	}
}


  
function moveBeforeFirstElementsByClassName(aClassName) {
	//console.log("la classe cherchee:"+aClassName);
	eltsSelected=document.getElementsByClassName(aClassName);
	a=eltsSelected.length;
	//console.log("Taille de la liste trouvee:"+a);
	for (i=0;i<a;i++){
		var item = eltsSelected[i];
		//console.log("Item traité:"+item);
		var parentItem=item.parentNode;
		//console.log("Item traité:"+parentItem);
		parentItem.removeChild(item);
		//console.log ("element retiré");
		parentItem.insertBefore(item,parentItem.childNodes[0]);
	}
}

function moveUpBeforeElementsByClassName(aClassName) {
	//console.log("la classe cherchee:"+aClassName);
	eltsSelected=document.getElementsByClassName(aClassName);
	a=eltsSelected.length;
	//console.log("Taille de la liste trouvee:"+a);
	for (i=0;i<a;i++){
		var item = eltsSelected[i];
		//console.log("Item traité:"+item);
		var parentItem=item.parentNode;
		var grandParentItem=parentItem.parentNode;
		//console.log("Item traité:"+parentItem);
		parentItem.removeChild(item);
		//console.log ("element retiré");
		grandParentItem.insertBefore(item,parentItem);
	}
}

function addAParentElementOfClass(aClassName, newEltName) {
	console.log("la classe cherchee:"+aClassName);
	eltsSelected=document.getElementsByClassName(aClassName);
	a=eltsSelected.length;
	console.log("Taille de la liste trouvee:"+a);
	for (i=a-1;i>=0;i--){
		
		var item = eltsSelected[i];
		console.log("Item traité:"+item+ " "+item.nodeName);
			console.log ("item qui va etre traité ["+item.nodeName+"]");
			var parentItem=item.parentNode;
			console.log("Item traité:"+parentItem);
			var elt=document.createElement("section");
			parentItem.removeChild(item);
			elt.appendChild(item);
			console.log ("element qui va etre ajoute ["+elt.nodeName+"]");
			parentItem.appendChild(elt);

	}
}


String.prototype.removeEndingTwoPointsByASpace = function() {
	// remove : at the end of the string
	return this.replace(/\s*:\s+$/,"&nbsp");
}

String.prototype.removeContentNumberBetweenParenthesis = function() {
	// remove : at the end of the string
	return this.replace(/\s*\(\s*\d+\s*\)/g,"");
}



$( window ).load(function(){
$( "#inserted" ).load( "https://bil.inria.fr/fr/catalog/quickview/584?catalogTemplateName=Template9&lang=fr" );
liste=document.images;
for (i = 0; i < liste.length; i++) {

    if(liste[i].hasAttribute("width")) {liste[i].removeAttribute("width");}
    if(liste[i].hasAttribute("height")) {liste[i].removeAttribute("height");}
    if(liste[i].hasAttribute("heigth")) {liste[i].removeAttribute("heigth");}
};

removeElementsByClassName("bil-SoftIllustrationLabel");
removeElementsByClassName("bil-SoftLogoLabel");


// Ordonnancement
moveUpBeforeElementsByClassName("bil-SoftLogo");


// Putting to top (result order = inverse order of operations)
moveBeforeFirstElementsByClassName("bil-SoftExecutionEnvironment"); 	
moveBeforeFirstElementsByClassName("bil-SoftMainScope"); 			
moveBeforeFirstElementsByClassName("bil-SoftInnovativeAspect");
moveBeforeFirstElementsByClassName("bil-SoftIllustration"); 
moveBeforeFirstElementsByClassName("bil-SoftDescription"); 		
// other present (added) elements in the middle stay in the middle

// Putting to end
moveAtEndElementsByClassName("bil-SoftContact");
moveAtEndElementsByClassName("bil-SoftKeyword");

//Permet d'ajouter un br donc un saut de ligne
//addingABr("bil-value");

liste=document.getElementsByClassName("bil-SoftName");
nb=liste.lenght;
//console.log("taille liste "+liste.length)
for (i = 0; i < nb; i++) {
	if ( (i%2)=== 0) {
		liste[i].className += "bil-SoftName-begin-page";
		//console.log("added a bil-software-begin-page class for "+i );
		}
}

// removing :
liste=document.getElementsByClassName("bil-label");
nb=liste.length;
console.log("taille liste bil-label :"+liste.length);
for (i = 0; i < nb; i++) {
		//console.log("removing : from "+liste[i].innerHTML );
		liste[i].innerHTML = liste[i].innerHTML.removeEndingTwoPointsByASpace();
		//console.log("removed : from "+liste[i].innerHTML );
		}

// removing (5678..) in bil-SoftLanguageValue :
liste=document.getElementsByClassName("bil-SoftLanguageValue");
nb=liste.length;
//console.log("taille liste bil-label :"+liste.length);
for (i = 0; i < nb; i++) {
		//console.log("removing : from "+liste[i].innerHTML );
		liste[i].innerHTML = liste[i].innerHTML.removeContentNumberBetweenParenthesis();
		//console.log("removed : from "+liste[i].innerHTML );
		}

// ajout <section>
addAParentElementOfClass("bil-software","section");


});