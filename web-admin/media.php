<?php
declare(strict_types=1);
?><!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Fila - Mídia Institucional</title>
<style>
body{font-family:system-ui,sans-serif;margin:0;background:#f5f6f8;color:#20242a}
header{padding:18px 24px;background:#fff;border-bottom:1px solid #ddd;display:flex;gap:12px;align-items:center;flex-wrap:wrap}
main{padding:24px;max-width:1200px;margin:auto}
.card{background:#fff;border:1px solid #ddd;border-radius:10px;padding:18px;margin-bottom:18px}
button,input{font:inherit;padding:8px 10px}button{cursor:pointer}
table{width:100%;border-collapse:collapse;background:#fff;border:1px solid #ddd}
th,td{padding:10px;border-bottom:1px solid #eee;text-align:left;vertical-align:middle}
th{background:#fafafa}
input[type=number]{width:90px}
.actions{display:flex;gap:5px;flex-wrap:wrap}.error{color:#a00}.ok{color:#167a3d}.muted{color:#666}
</style>
</head>
<body>
<header>
  <strong>Projeto Fila — Mídia Institucional</strong>
  <a href="panels.php">← Painéis</a>
  <a href="releases.php">Releases</a>
  <input id="token" type="password" placeholder="Token administrativo">
  <button onclick="saveToken()">Conectar</button>
  <span id="msg"></span>
</header>
<main>
  <div class="card">
    <h2>Enviar mídia</h2>
    <p class="muted">Formatos: JPG, JPEG, PNG, WEBP, MP4 e WEBM. Limite por arquivo: 200 MB.</p>
    <input id="mediaFile" type="file" accept=".jpg,.jpeg,.png,.webp,.mp4,.webm,image/*,video/mp4,video/webm">
    <button onclick="uploadMedia()">Enviar</button>
  </div>

  <div class="card">
    <h2>Playlist</h2>
    <p>
      URL para configurar nas TVs:
      <code id="playlistUrl"></code>
    </p>
    <div style="overflow:auto">
      <table>
        <thead><tr><th>Ordem</th><th>Arquivo</th><th>Tipo</th><th>Tamanho</th><th>Ativo</th><th>Duração (s)</th><th>Ações</th></tr></thead>
        <tbody id="rows"></tbody>
      </table>
    </div>
    <button onclick="savePlaylist()">Salvar ordem/configuração</button>
  </div>
</main>
<script>
const tokenEl=document.getElementById('token');
tokenEl.value=localStorage.getItem('filaAdminToken')||'';
let items=[];
document.getElementById('playlistUrl').textContent=new URL('media/playlist.php',location.href).href;

function headers(json=true){
  const h={'X-Admin-Token':tokenEl.value};
  if(json) h['Content-Type']='application/json';
  return h;
}
function saveToken(){localStorage.setItem('filaAdminToken',tokenEl.value);loadMedia()}
function esc(v){return String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]))}
function fmtBytes(v){
  v=Number(v||0); if(v<1024)return v+' B'; if(v<1048576)return(v/1024).toFixed(1)+' KB'; return(v/1048576).toFixed(1)+' MB';
}
async function api(url,opt={}){
  const r=await fetch(url,{...opt,headers:{...headers(true),...(opt.headers||{})}});
  const j=await r.json();
  if(!r.ok||!j.ok)throw new Error(j.error||'Falha na requisição');
  return j;
}
function message(text,ok=true){document.getElementById('msg').innerHTML='<span class="'+(ok?'ok':'error')+'">'+esc(text)+'</span>'}
async function loadMedia(){
  try{
    const j=await api('media_api.php');
    items=j.items||[];
    render();
    message('Atualizado');
  }catch(e){message(e.message,false)}
}
function render(){
  document.getElementById('rows').innerHTML=items.map((m,i)=>
    '<tr>'+
      '<td><button onclick="move('+i+',-1)">↑</button> <button onclick="move('+i+',1)">↓</button> '+(i+1)+'</td>'+
      '<td>'+esc(m.file)+'</td>'+
      '<td>'+esc(m.type)+'</td>'+
      '<td>'+fmtBytes(m.size)+'</td>'+
      '<td><input type="checkbox" '+(m.enabled?'checked':'')+' onchange="items['+i+'].enabled=this.checked"></td>'+
      '<td>'+(m.type==='image'?'<input type="number" min="1" max="3600" value="'+Number(m.duration||12)+'" onchange="items['+i+'].duration=Number(this.value)">':'—')+'</td>'+
      '<td><button onclick="deleteMedia('+i+')">Excluir</button></td>'+
    '</tr>'
  ).join('');
}
function move(i,delta){
  const j=i+delta;if(j<0||j>=items.length)return;
  [items[i],items[j]]=[items[j],items[i]];render();
}
async function uploadMedia(){
  const file=document.getElementById('mediaFile').files[0];if(!file){message('Selecione um arquivo.',false);return}
  const fd=new FormData();fd.append('action','UPLOAD');fd.append('file',file);
  try{
    message('Enviando...');
    const r=await fetch('media_api.php',{method:'POST',headers:headers(false),body:fd});
    const j=await r.json();if(!r.ok||!j.ok)throw new Error(j.error||'Falha no upload');
    items=j.items||[];render();message('Mídia enviada.');
  }catch(e){message(e.message,false)}
}
async function savePlaylist(){
  try{
    const payload={action:'SAVE',items:items.map((m,i)=>({file:m.file,enabled:!!m.enabled,duration:Number(m.duration||12),order:i+1}))};
    const j=await api('media_api.php',{method:'POST',body:JSON.stringify(payload)});
    items=j.items||[];render();message('Playlist salva.');
  }catch(e){message(e.message,false)}
}
async function deleteMedia(i){
  if(!confirm('Excluir '+items[i].file+'?'))return;
  try{
    const j=await api('media_api.php',{method:'POST',body:JSON.stringify({action:'DELETE',file:items[i].file})});
    items=j.items||[];render();message('Mídia excluída.');
  }catch(e){message(e.message,false)}
}
if(tokenEl.value)loadMedia();
</script>
</body>
</html>
