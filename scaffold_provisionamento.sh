#!/bin/bash
# ===================================================================
#  SCAFFOLD - provisionamento.sh
#  Aula 07 - Provisionamento e Automacao de Instalacao
#
#  Este arquivo NAO tem codigo pronto - so o roteiro em comentarios.
#  Cada linha indica qual Peca usar naquele ponto (ver slides/README).
#  Substituam os comentarios pelo codigo real, mantendo a ordem.
# ===================================================================

# 1) Variaveis + cabecalho no log (Pecas 1, 2, 4)
LOGFILE="log_$(hostname).txt"
echo "Início: $(date)" > "$LOGFILE"
apps=(curl tree htopz)
ok_count=0
fail_count=0
# 2) [se precisar] Verificar root (Peca 7)
if [ "$EUID" -ne 0 ]; then
echo "Precisa ser root."
exit 1
fi
# 3) sudo apt update
sudo apt update
# 4) for em "apps" (Peca 2):
#    - instalar / [ja instalado? Peca 8] / [tentar de novo Peca 9]
#    - if/else + contadores + log (Pecas 3, 4, 5) — NAO usar "set -e"
for app in "${apps[@]}"; do
t=0
ok=1
while [ $t -lt 2 ] && [ $ok -ne 0 ]; do
sudo apt install -y "$app"
ok=$?
t=$((t+1))
done
if [ $? -ne 0 ]; then
echo "[FALHA] $app" >> "$LOGFILE"
fail_count=$((fail_count+1))
else
echo "[OK] $app" >> "$LOGFILE"
ok_count=$((ok_count+1))
fi
done
echo "Sucesso: $ok_count | Falhas: $fail_count" | tee -a "$LOGFILE"
# 5) Resumo final no log

# 6) [se precisar] os dois requisitos do grupo
