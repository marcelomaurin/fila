<?php
declare(strict_types=1);
?><!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Fila - Releases PainelAndroid</title>
<style>
body{font-family:system-ui,sans-serif;margin:0;background:#f5f6f8;color:#20242a}
header{padding:18px 24px;background:#fff;border-bottom:1px solid #ddd;display:flex;gap:12px;align-items:center;flex-wrap:wrap}
main{padding:24px;max-width:900px;margin:auto}
.card{background:#fff;border:1px solid #ddd;border-radius:10px;padding:20px;margin-bottom:18px}
label{display:block;font-weight:600;margin-top:12px}
input,button{font:inherit;padding:9px 11px}
input[type=text],input[type=number],input[type=password]{width:min(520px,95%)}
button{cursor:pointer;margin-top:16px}
.error{color:#a00}.ok{color:#167a3d}
pre{white-space:pre-wrap;word-break:break-word;background:#f7f7f7;padding:12px}
</style>
</head>
<body>
<header>
  <strong>Projeto Fila — Releases PainelAndroid</strong>
  <a href="panels.php">← Painéis</a>
  <a href="media.php">Mídia</a>
  <input id="token" type="password" placeholder="Token administrativo">
  <button onclick="saveToken()">Conectar</button>
  <span id="msg"></span>
</header>
<main>
  <div class="card">
    <h2>Publicar nova versão</h2>
    <p>Envie aqui o APK <strong>release assinado</strong>. A central calcula SHA-256 e passa a oferecê-lo às TVs.</p>

    <label for="versionName">Versão</label>
    <input id="versionName" type="text" placeholder="2.7.0">

    <label for="versionCode">Version code</label>
    <input id="versionCode" type="number" min="1" placeholder="6">

    <label for="apk">APK assinado</label>
    <input id="apk" type="file" accept=".apk,application/vnd.android.package-archive">

    <br>
    <button onclick="publishRelease()">Publicar release</button>
  </div>

  <div class="card">
    <h2>Última publicação</h2>
    <pre id="result">Nenhuma publicação nesta sessão.</pre>
  </div>
</main>
<script>
const tokenEl=document.getElementById('token');
tokenEl.value=localStorage.getItem('filaAdminToken')||'';
function saveToken(){localStorage.setItem('filaAdminToken',tokenEl.value);document.getElementById('msg').textContent='Token salvo'}
function esc(v){return String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]))}
async function publishRelease(){
  const file=document.getElementById('apk').files[0];
  if(!file){document.getElementById('msg').innerHTML='<span class="error">Selecione o APK.</span>';return}

  const fd=new FormData();
  fd.append('version_name',document.getElementById('versionName').value.trim());
  fd.append('version_code',document.getElementById('versionCode').value.trim());
  fd.append('apk',file);

  document.getElementById('msg').textContent='Enviando...';
  try{
    const r=await fetch('api/release_upload.php',{
      method:'POST',
      headers:{'X-Admin-Token':tokenEl.value},
      body:fd
    });
    const j=await r.json();
    if(!r.ok||!j.ok) throw new Error(j.error||'Falha na publicação');
    document.getElementById('msg').innerHTML='<span class="ok">Release publicada.</span>';
    document.getElementById('result').textContent=JSON.stringify(j.release,null,2);
  }catch(e){
    document.getElementById('msg').innerHTML='<span class="error">'+esc(e.message)+'</span>';
  }
}
</script>
</body>
</html>
