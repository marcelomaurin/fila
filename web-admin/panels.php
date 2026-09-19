<?php
declare(strict_types=1);
?><!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Fila - Painéis</title>
<style>
body{font-family:system-ui,sans-serif;margin:0;background:#f5f6f8;color:#20242a}
header{padding:18px 24px;background:#fff;border-bottom:1px solid #ddd;display:flex;gap:12px;align-items:center;flex-wrap:wrap}
main{padding:24px;max-width:1500px;margin:auto}
a{color:inherit}
button,input{font:inherit;padding:8px 10px}
button{cursor:pointer}
table{width:100%;border-collapse:collapse;background:#fff;border:1px solid #ddd}
th,td{padding:10px;border-bottom:1px solid #eee;text-align:left;vertical-align:top}
th{background:#fafafa;position:sticky;top:0}
.actions{display:flex;gap:5px;flex-wrap:wrap}
.online{font-weight:700;color:#167a3d}
.offline{font-weight:700;color:#a33}
.muted{color:#666;font-size:.9em}
.error{color:#a00}
</style>
</head>
<body>
<header>
  <strong>Projeto Fila — Painéis TV</strong>
  <a href="index.php">← Atendimento</a>
  <a href="media.php">Mídia</a>
  <a href="releases.php">Releases</a>
  <input id="token" type="password" placeholder="Token administrativo">
  <button onclick="saveToken()">Conectar</button>
  <button onclick="refreshPanels()">Atualizar</button>
  <span id="msg"></span>
</header>
<main>
  <h2>Painéis registrados</h2>
  <div style="overflow:auto;max-height:78vh">
    <table>
      <thead><tr>
        <th>Status</th><th>Painel</th><th>Unidade</th><th>Rede</th>
        <th>Versão</th><th>Uso</th><th>Última chamada</th><th>Erro</th><th>Ações</th>
      </tr></thead>
      <tbody id="rows"></tbody>
    </table>
  </div>
</main>
<script>
const tokenEl=document.getElementById('token');
tokenEl.value=localStorage.getItem('filaAdminToken')||'';
function headers(){return {'X-Admin-Token':tokenEl.value,'Content-Type':'application/json'}}
function saveToken(){localStorage.setItem('filaAdminToken',tokenEl.value);refreshPanels()}
function esc(v){return String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]))}
function fmtUptime(v){
  v=Number(v||0); const h=Math.floor(v/3600),m=Math.floor((v%3600)/60),s=Math.floor(v%60);
  return String(h).padStart(2,'0')+':'+String(m).padStart(2,'0')+':'+String(s).padStart(2,'0');
}
async function api(url,opt={}){
  const r=await fetch(url,{...opt,headers:{...headers(),...(opt.headers||{})}});
  const j=await r.json();
  if(!r.ok||!j.ok) throw new Error(j.error||'Falha na requisição');
  return j;
}
function showError(e){document.getElementById('msg').innerHTML='<span class="error">'+esc(e.message)+'</span>'}
async function refreshPanels(){
  document.getElementById('msg').textContent='Carregando...';
  try{
    const j=await api('api/panels.php');
    document.getElementById('rows').innerHTML=j.panels.map(p=>{
      const online=Number(p.online)===1;
      const status=online?'<span class="online">● ONLINE</span>':'<span class="offline">● OFFLINE</span>';
      const name=esc(p.nome||p.painel_id);
      const id=esc(p.painel_id);
      return '<tr>'+
        '<td>'+status+'<div class="muted">'+esc(p.last_seen||'Nunca')+'</div></td>'+
        '<td><strong>'+name+'</strong><div class="muted">'+id+'</div></td>'+
        '<td>'+esc(p.unidade||'')+'</td>'+
        '<td>'+esc(p.ip||'')+'<div class="muted">TCP '+esc(p.tcp_status||'')+' / '+esc(p.porta||'')+'</div></td>'+
        '<td>'+esc(p.versao||'')+'</td>'+
        '<td>Uptime '+fmtUptime(p.uptime_seg)+'<div class="muted">'+esc(p.call_count||0)+' chamadas</div></td>'+
        '<td>'+esc(p.ultima_senha||'')+' / '+esc(p.ultimo_guiche||'')+'</td>'+
        '<td>'+esc(p.ultimo_erro||'')+'</td>'+
        '<td><div class="actions">'+
          '<button onclick="testPanel('+JSON.stringify(p.painel_id)+')">Teste</button>'+
          '<button onclick="restartTcp('+JSON.stringify(p.painel_id)+')">Reiniciar TCP</button>'+
          '<button onclick="configurePanel('+encodeURIComponent(JSON.stringify(p))+')">Configurar</button>'+
        '</div></td></tr>';
    }).join('');
    document.getElementById('msg').textContent='Atualizado';
  }catch(e){showError(e)}
}
async function sendAction(body){
  await api('api/panel_action.php',{method:'POST',body:JSON.stringify(body)});
}
async function testPanel(id){
  const ticket=prompt('Senha de teste:','T001'); if(ticket===null)return;
  const desk=prompt('Guichê:','01'); if(desk===null)return;
  try{await sendAction({panel_id:id,action:'TEST_CALL',ticket,desk});document.getElementById('msg').textContent='Teste enfileirado';}
  catch(e){showError(e)}
}
async function restartTcp(id){
  try{await sendAction({panel_id:id,action:'RESTART_TCP'});document.getElementById('msg').textContent='Reinício enfileirado';}
  catch(e){showError(e)}
}
async function configurePanel(encoded){
  const p=JSON.parse(decodeURIComponent(encoded));
  const name=prompt('Nome do painel:',p.nome||''); if(name===null)return;
  const unit=prompt('Unidade/local:',p.unidade||''); if(unit===null)return;
  const port=prompt('Porta TCP:',p.desired_port||p.porta||8196); if(port===null)return;
  const tts=confirm('Ativar voz TTS?');
  const chime=confirm('Ativar alerta sonoro?');
  const ads=prompt('URL de mídia/anúncios:',p.desired_ads_url??p.ads_url??''); if(ads===null)return;
  try{
    await sendAction({panel_id:p.painel_id,action:'CONFIG',name,unit,port:Number(port),tts_enabled:tts,chime_enabled:chime,ads_url:ads});
    document.getElementById('msg').textContent='Configuração enfileirada';
    setTimeout(refreshPanels,1200);
  }catch(e){showError(e)}
}
if(tokenEl.value) refreshPanels();
setInterval(()=>{if(tokenEl.value) refreshPanels()},15000);
</script>
</body>
</html>
