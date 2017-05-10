#!/bin/bash 
#
# sounds-bkp.sh - Programa feito para realizar o Backup completo dos arquivos de audio do Asterisk. Nao incluem gravacoes.
#
# Autor: Anderson Freitas <tmsi.freitas@gmail.com>
# Site: http://www.dialplanreload.com/
# Repositorio: https://github.com/DialplanReload/sounds-bkp
#
# Desenvolvido sob licensa GPL.
# Fique a vontade para contribuir com a evolucao deste programa.
#
#-----------------------------------------------------------------------------------------------
# Save Info

# Directorie to save archives
bkp_dir_sounds=/home/backup/sounds
bkp_dir_moh=/home/backup/moh
# Number of archives
NUM_BKP=5

# Tools
date=$(date +%d%h%Y_%H%M%S_%N)

path_tar=$(which tar)
path_ls=$(which ls)
path_egrep=$(which egrep)
path_awk=$(which awk)
path_head=$(which head)
path_tr=$(which tr)
path_sed=$(which sed)
path_rm=$(which rm)

# Directories
sounds=/var/lib/asterisk/sounds
moh=/var/lib/asterisk/moh

# Actions
# FIRST ACTION - BACKUP ASTERISK SOUNDS

	cd $bkp_dir_sounds
	$path_tar -cvf asterisk_sounds_${date}.tar.gz $sounds

# EFETUAR ROTATIVIDADE DE ARQUIVOS

     ult_bkp_ast_sounds=$(
          $path_ls -tl $bkp_dir_sounds/ |
          $path_egrep -v total |
          $path_awk '{print $9}' |
          $path_head -$NUM_BKP |
          $path_tr '\n' '|' |
          $path_sed  "s/.$//"
     )

     for check_ast_sounds in `${path_ls} -lt $bkp_dir_sounds |
          ${path_awk} '{print $9}' |
          ${path_egrep} -v "${ult_bkp_ast_sounds}"`; 	

     do 

          `${path_rm} -f $bkp_dir_sounds/$check_ast_sounds`;

     done

# NEXT ACTION - BACKUP ASTERISK MOH

        cd $bkp_dir_moh
        $path_tar -cvf asterisk_moh_${date}.tar.gz $moh

# EFETUAR ROTATIVIDADE DE ARQUIVOS

     ult_bkp_ast_moh=$(
          $path_ls -tl $bkp_dir_moh/ |
          $path_egrep -v total |
          $path_awk '{print $9}' |
          $path_head -$NUM_BKP |
          $path_tr '\n' '|' |
          $path_sed  "s/.$//"
     )

     for check_ast_moh in `${path_ls} -lt $bkp_dir_moh |
          ${path_awk} '{print $9}' |
          ${path_egrep} -v "${ult_bkp_ast_moh}"`;

     do

          `${path_rm} -f $bkp_dir_moh/$check_ast_moh`;

     done

