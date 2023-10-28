#!/bin/bash

if [ $# -eq 0 ]
then
	echo "USAGE: $0 [output_dir]"
	exit 1
fi

# TO LOOK INTO:
#https://github.com/maverickNerd/wordlists/blob/master/SecListsCurated/quickhits.txt
#https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/aem2.txt
#https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content/CMS
#https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content/WebTechnologyPaths-Trickest-Wordlists

out_dir=$1
tmp_dir=`mktemp -d`
trap "rm -rf $tmp_dir" EXIT

cd $tmp_dir
mkdir -p $out_dir/tech/

git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/assetnote/commonspeak2-wordlists
wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH

high_impact_lists=( 
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/UnixDotfiles.fuzz.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/bak.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/Common-DB-Backups.txt"
	"https://raw.githubusercontent.com/aristosMiliaressis/wordlist_builder/master/temp/high-impact-files.txt"

	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/hashicorp-vault.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/hashicorp-consul-api.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-ASP.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-JSP.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-PHP.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-PL.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/vulnerability-scan_j2ee-websites_WEB-INF.txt"
	"https://raw.githubusercontent.com/aristosMiliaressis/wordlist_builder/master/temp/high-impact-endpoints.txt"
)

file_lists=(
	"https://wordlists-cdn.assetnote.io/data/manual/raft-medium-files.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/xml_filenames.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_xml_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_txt_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_html_htm_2023_06_28.txt"
)

directory_lists=(
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-directories.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-lowercase-2.3-big.txt"
	#"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/KitchensinkDirectories.fuzz.txt"
)

iis_asp_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_aspx_asp_cfm_svc_ashx_asmx_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/asp_lowercase.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/aspx_lowercase.txt"
	"https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/wordswithext/aspx.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/IIS.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/iis-systemweb.txt"
	"https://raw.githubusercontent.com/SooLFaa/fuzzing/master/webserver/iis.txt"
)
tomcat_jsp_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_jsp_jspa_do_action_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/do.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/jsp.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/tomcat.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/ApacheTomcat.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/WebTechnologyPaths-Trickest-Wordlists/tomcat-all-levels.txt"
)
apache_php_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_php_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_cgi_pl_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/php.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/pl.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/Apache.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/apache.txt"
)
nginx_wordlists=(
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/nginx.txt"
)
rails_wordlists=(
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/ror.txt"
)

api_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_apiroutes_2023_06_28.txt"
)

read_from_stdin() {
	while read line
	do
	  echo "$line"
	done < "${1:-/dev/stdin}"
}

normalize_prefix() {
	read_from_stdin | sed 's/\r\n/\n/g' | sed 's/\n\//\n/g'
}

filter_junk() {
	read_from_stdin \
		| rev | cut -d '/' -f 1 | cut -d '\' -f 1 | rev \
		| grep -E '[A-Za-z0-9]' \
		| grep -Ev '.{100,}' \
		| grep -a -v 'filename:' \
		| grep -v '\.\.' \
		| grep -v \* \
		| grep -v '#' \
		| grep -v '%' \
		| grep -v '&' \
		| grep -v "??" \
		| grep -v "$$" \
		| grep -v '\- ' \
		| grep -v '>>' \
		| grep -v '::' \
		| filter_recursive_deadends \
		| sort -u
}

filter_files() {
	read_from_stdin \
		| grep -Ev '\.(css|js|png|jpg|jpeg|woff|gif|ico|ttf|woff2|eot|pdf)' 2>/dev/null
}

grep_high_impact_extensions() {
	grep -a -hirE '\.(log|ovpn|bz2|tgz|bzip2|pem|crt|key|gzip|settings|setting|passwd|sh|pac|swp|sav|bak|backup|tar|zip|7z|gz|lz|xz|z|rar|war|db|sqlite|sqlitedb|sqlite3|mdb|sql|ini|cfg|conf|config|properties|ppk|env|rdp|pgp|psql)$' \
		| filter_junk
}

grep_all_extensions() {
	grep -a -hirE '\.(log|bz2|tgz|bzip2|pac|key|gzip|txt|inc|passwd|out|pac|swp|sav|lst|bak|backup|bkpold|tar|zip|7z|gz|rar|iso|db|sqlite|sqlite3|mdb|sql|ini|conf|cfg|config|properties|json|xml|dtd|xslt|yml|yaml|csv|dat|xls|xlsx|pem|crt|ppk|sh|exs|env|tpl|swf|reg|rdp|pwl|pub|old|cache|pgp|psql|site|dtd|xslt|war|default|bkp|sav|lst|img|cur|ai|data|bat|bin|msi|tmp|eml|epl|ssi|ssf)$' \
		| filter_junk
}

filter_recursive_deadends() {
	read_from_stdin \
		| grep -Eiv '^(img|image|images|font|fonts|css|style|styles|resources|assets)[\/]*$'
}

lowercase() {
	read_from_stdin | tr '[:upper:]' '[:lower:]' | sort -u
}

filter_duplicates() {
	temp=`mktemp`
	cat $1 | sort -u > $temp
	cat $temp > $1
	rm $temp
}

deduplicate() {
	temp=`mktemp`
	cat $1 > $temp
	read_from_stdin | anew $temp
}

for list in "${high_impact_lists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | anew $out_dir/high_impact.txt >/dev/null
	rm $temp
done

grep_high_impact_extensions | anew $out_dir/high_impact.txt >/dev/null
filter_duplicates $out_dir/high_impact.txt

cat $out_dir/high_impact.txt | lowercase | tee $out_dir/high_impact_lowercase.txt

for list in "${file_lists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | anew $out_dir/large_files.txt >/dev/null
	rm $temp
done
grep_all_extensions | anew $out_dir/large_files.txt >/dev/null
filter_duplicates $out_dir/large_files.txt
cat $out_dir/large_files.txt | deduplicate $out_dir/high_impact.txt > $out_dir/dedublicated_large_files.txt

for list in "${directory_lists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | filter_recursive_deadends | filter_files | anew $out_dir/directories.txt >/dev/null
	rm $temp
done
filter_duplicates $out_dir/directories.txt

cat $out_dir/directories_lowercase.txt | lowercase > $out_dir/directories_lowercase.txt

for list in "${iis_asp_wordlists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/iis_asp.txt >/dev/null
	rm $temp
done

grep -a -hirE '\.(asp|aspx|ashx|asmx|wsdl|wadl|axd|asax)$' \
	| filter_junk >>  $out_dir/tech/iis_asp.txt
filter_duplicates $out_dir/tech/iis_asp.txt

for list in "${tomcat_jsp_wordlists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/tomcat_jsp.txt >/dev/null
	rm $temp
done

grep -a -hirE '\.(jsp|jspa|do|action)$' \
	| filter_junk  >>  $out_dir/tech/tomcat_jsp.txt
filter_duplicates $out_dir/tech/tomcat_jsp.txt

for list in "${apache_php_wordlists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/apache_php.txt >/dev/null
	rm $temp
done

grep -a -hirE '\.(php|cgi)$' \
	| filter_junk  >>  $out_dir/tech/apache_php.txt
filter_duplicates $out_dir/tech/apache_php.txt

for list in "${nginx_wordlists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/nginx.txt >/dev/null
	rm $temp
done
filter_duplicates $out_dir/tech/nginx.txt

# for list in "${django_wordlists[@]}"
# do
	# temp=`mktemp`
	# curl -s $list -o $temp
	# cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/django.txt >/dev/null
	# rm $temp
# done
# filter_duplicates $out_dir/tech/django.txt

# for list in "${flask_wordlists[@]}"
# do
	# temp=`mktemp`
	# curl -s $list -o $temp
	# cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/flask.txt >/dev/null
	# rm $temp
# done
# filter_duplicates $out_dir/tech/flask.txt

# for list in "${express_wordlists[@]}"
# do
	# temp=`mktemp`
	# curl -s $list -o $temp
	# cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/express.txt >/dev/null
	# rm $temp
# done
# filter_duplicates $out_dir/tech/express.txt

for list in "${rails_wordlists[@]}"
do
	temp=`mktemp`
	curl -s $list -o $temp
	cat $temp | normalize_prefix | filter_junk | anew $out_dir/tech/rails.txt >/dev/null
	rm $temp
done
filter_duplicates $out_dir/tech/rails.txt

cd - >/dev/null
