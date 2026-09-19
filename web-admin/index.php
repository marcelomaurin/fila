<?php
declare(strict_types=1);
?><!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Fila - Administração</title>
<style>
body{font-family:system-ui,sans-serif;margin:0;background:#f5f6f8;color:#20242a}
header{padding:18px 24px;background:#fff;border-bottom:1px solid #ddd;display:flex;gap:12px;align-items:center;flex-wrap:wrap}
main{padding:24px;max-width:1400px;margin:auto}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:12px;margin-bottom:20px}
.card{background:#fff;border:1px solid #ddd;border-radius:10px;padding:16px}
.card b{font-size:28px;display:block;margin-top:6px}
table{width:100%;border-collapse:collapse;background:#fff;border:1px solid #ddd}
th,td{padding:10px;border-bottom:1px solid #eee;text-align:left}
th{background:#fafafa;position:sticky;top:0}
button,input{font:inherit;padding:8px 10px}
button{cursor:pointer}
.actions{display:flex;gap:5px;flex-wrap:wrap}
.status{font-weight:600}
.error{color:#a00}
small{color:#666}
</style>
</head>
<body>
<header>
  <strong>Projeto Fila — Administração</strong>
  <a href="panels.php">Painéis TV</a>
  <input id="token" type="password" placeholder="Token administrativo">
  <button onclick="saveToken()">Conectar</button>
  <button onclick="refreshAll()">Atualizar</button>
  <span id="msg"></span>
</header>
<main>
  <div class="cards" id="cards"></div>
  <h2>Senhas recentes</h2>
  <div style="overflow:auto;max-height:65vh">
    <table>
      <thead><tr>
        <th>Senha</th><th>Fila</th><th>Prioridade</th><th>Status</th>
        <th>Guichê</th><th>Emitida</th><th>Chamada</th><th>Ações</th>
      </tr></thead>
      <tbody id="rows"></tbody>
    </table>
  </div>
</main>
<script>
const tokenEl=document.getElementById('token');
tokenEl.value=localStorage.getItem('filaAdminToken')||'';
function headers(){return {'X-Admin-Token':tokenEl.value,'Content-Type':'application/json'}}
function saveToken(){localStorage.setItem('filaAdminToken',tokenEl.value);refreshAll()}
function fmtSec(v){v=Number(v||0); return v<60?Math.round(v)+' s':(v/60).toFixed(1)+' min'}
async function api(url,opt={}) {
  const r=await fetch(url,{...opt,headers:{...headers(),...(opt.headers||{})}});
  const j=await r.json();
  if(!r.ok||!j.ok) throw new Error(j.error||'Falha na requisição');
  return j;
}
async function refreshStats(){
  const j=await api('api/stats.php');
  const m=j.metrics;
  const cards=[
    ['Aguardando',m.aguardando],['Chamadas',m.chamadas],['Em atendimento',m.em_atendimento],
    ['Finalizadas hoje',m.finalizadas_hoje],['Ausentes hoje',m.ausentes_hoje],
    ['Canceladas hoje',m.canceladas_hoje],['Espera média',fmtSec(m.espera_media_seg)],
    ['Atendimento médio',fmtSec(m.atendimento_medio_seg)]
  ];
  document.getElementById('cards').innerHTML=cards.map(c=>'<div class="card"><small>'+c[0]+'</small><b>'+(c[1]??0)+'</b></div>').join('');
}
function buttons(t){
  const c=JSON.stringify(t.codigo);
  const g=JSON.stringify(t.guiche||'');
  let a=[];
  if(t.status==='CHAMADA') a.push('<button onclick=act("INICIAR",'+c+','+g+')>Iniciar</button>');
  if(t.status==='EM_ATENDIMENTO') a.push('<button onclick=act("FINALIZAR",'+c+','+g+')>Finalizar</button>');
  if(['CHAMADA','EM_ATENDIMENTO'].includes(t.status)) a.push('<button onclick=act("AUSENTE",'+c+','+g+')>Ausente</button>');
  if(['AGUARDANDO','CHAMADA','EM_ATENDIMENTO'].includes(t.status)) a.push('<button onclick=cancelTicket('+c+','+g+')>Cancelar</button>');
  return a.join('');
}
async function refreshTickets(){
  const j=await api('api/tickets.php?limit=200');
  document.getElementById('rows').innerHTML=j.tickets.map(t=>'<tr>'+
    '<td>'+t.codigo+'</td><td>'+t.fila_id+'</td><td>'+t.prioridade+'</td>'+
    '<td class="status">'+t.status+'</td><td>'+(t.guiche||'')+'</td>'+
    '<td>'+t.emitida_em+'</td><td>'+(t.chamada_em||'')+'</td>'+
    '<td><div class="actions">'+buttons(t)+'</div></td></tr>').join('');
}
async function act(action,codigo,guiche,motivo=''){
  try{
    await api('api/action.php',{method:'POST',body:JSON.stringify({action,codigo,guiche,motivo})});
    await refreshAll();
  }catch(e){showError(e)}
}
function cancelTicket(codigo,guiche){
  const motivo=prompt('Motivo do cancelamento:','');
  if(motivo===null)return;
  act('CANCELAR',codigo,guiche,motivo);
}
function showError(e){document.getElementById('msg').innerHTML='<span class="error">'+e.message+'</span>'}
async function refreshAll(){
  document.getElementById('msg').textContent='Carregando...';
  try{await Promise.all([refreshStats(),refreshTickets()]);document.getElementById('msg').textContent='Atualizado';}
  catch(e){showError(e)}
}
if(tokenEl.value) refreshAll();
setInterval(()=>{if(tokenEl.value) refreshAll()},15000);
</script>
</body>
</html>
