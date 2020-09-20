if [ ${PERSO_ENABLED} = 1 ] ; then
 tipsdatabase () {
  echo -e "Some Database Tips:" \
  "\nPostgreSQL:" \
  "\nsu - postgres" \
  "\n createdb ttrssdb" \
  "\n createuser ttrssuser" \
  "\n psql" \
  "\n    alter user ttrssuser with encrypted password 'MOTDEPASSEACHANGER';" \
  "\n    grant all privileges on database ttrssdb to ttrssuser ;" \
  "\n" \
  "\ncreateuser -W -P ttrssuser" \
  "\ncreatedb -O ttrssuser ttrssdb" \
  "\n" \
  "\npg_dump -U ttrssuser ttrssdb > ttrss-ttrssvm-20190707-2.pgsql" \
  "\npsql -W -U ttrssuser ttrssdb < ttrss-ttrssvm-20190707-ttrssuser.pgsql"
 }
fi

