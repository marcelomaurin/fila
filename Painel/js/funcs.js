
function GetRedeIp() {
var xmlhttp = new XMLHttpRequest();
xmlhttp.open("GET", 'http://meuip.com/api/meuip.php');
xmlhttp.send();
xmlhttp.onload = function(e) {
  //alert("Seu IP é: "+xmlhttp.response);
  return xmlhttp.response;
}
}

function getIPs() {
 return "127.0.0.1";
};