import os
import regex
import szip
import flag

fn main()
{
	mut fp := flag.new_flag_parser(os.args)
    fp.application('doc2txt')
	
    fp.version('v2022.03.02\nCopyright (c) 2022 jeffrey -at- ieee.org. All rights \
	reserved.\nUse of this source code (/program) is governed by an MIT \
	license,\nthat can be found in the LICENSE file.')

    fp.description('\nConverts Microsoft Docx to plain text for easy analytics.\n\
	Output is to stdout, with each sentence as a seperate line break.\n\
	Useful for diff, grep, NLP, classification, and basic analytics.\n\
	This software will -NOT- make any changes to your MS Doc files.')

    fp.skip_executable()

    mut doc_arg := fp.string('doc', `f`, "", 
								'specify the .docx file for parsing')
										
	additional_args := fp.finalize() or {
        eprintln(err)	
        println(fp.usage())
        return
    }

	additional_args.join_lines()

	if doc_arg.len==0
	{
		eprintln("[ERROR] You must specify a MS Docx file for analysis.\nSee usage below.\n")
		println(fp.usage())
		exit(0)
		return
	}		

	mut res := szip.open(doc_arg,.best_speed,.read_only) ?

	res.open_entry('word/document.xml') ?

	// extract_entry checks if file exists first
	os.write_file('document.xml', '') ?
	res.extract_entry("document.xml") ? 

	res.close()

	//szip.extract_zip_to_dir("sample.docx", "unzip") or { panic(err) }

	mut lines := os.read_lines("document.xml") or {panic(err)}

	mut period_array := []string{}

	for mut line in lines
	{
		// Replace Microsoft garble....
		mut re1 := regex.regex_opt("<w:pPr>") or { panic(err) }
		line = re1.replace(line,".")
		mut re80 := regex.regex_opt("</w:p>") or { panic(err) }
		line = re80.replace(line,".")
		mut re16 := regex.regex_opt(r" PAGEREF.*-") or { panic(err) }
		line = re16.replace(line,"")
		mut re44 := regex.regex_opt(r"\* ARABIC") or { panic(err) }
		line = re44.replace(line,"")
		mut re45 := regex.regex_opt(r"TOC \\h \\z \\[tc] ") or { panic(err) }
		line = re45.replace(line,"")

		// Replace some common phrases with periods...
		mut re12 := regex.regex_opt("(http).*[ >]") or { panic(err) }
		line = re12.replace(line,"-weblink-")
		mut re55 := regex.regex_opt(r"etc\.") or { panic(err) }
		line = re55.replace(line,"etcetera;")
		mut re57 := regex.regex_opt(r"i\.e\.") or { panic(err) }
		line = re57.replace(line,"for instance;")
		mut re56 := regex.regex_opt(r"[0-9]{1,}\.[0-9]{1,}") or { panic(err) }
		line = re56.replace(line,"-reference number-;")

		mut re2 := regex.regex_opt("<.*>") or { panic(err) }
		line = re2.replace(line,"")

		// Replace period followed by 1 or more spaces, with period
		mut re7 := regex.regex_opt(r"\.[ ]{1,}") or { panic(err) }
		line = re7.replace(line,".")

		// Replace ? followed by 1 or more spaces, with ?
		mut re8 := regex.regex_opt(r"\?[ ]{1,}") or { panic(err) }
		line = re8.replace(line,"?")

		// Replace ! followed by 1 or more spaces, with !
		mut re9 := regex.regex_opt(r"\![ ]{1,}") or { panic(err) }
		line = re9.replace(line,"!")

		mut re58 := regex.regex_opt(r"[0-9]{1,}\.") or { panic(err) }
		line = re58.replace(line,r".")

		mut re3 := regex.regex_opt(r"\.") or { panic(err) }
		line = re3.replace(line,".\n")

		mut re4 := regex.regex_opt(r"\?") or { panic(err) }
		line = re4.replace(line,"?\n")

		mut re5 := regex.regex_opt(r"\!") or { panic(err) }
		line = re5.replace(line,"!\n")

		mut re81 := regex.regex_opt("\n[0-9]{1,}") or { panic(err) }
		line = re81.replace(line,"\n")

		period_array << line.split("\n")
	}

	
	for line in period_array
	{
		if compare_strings(line,".") !=0 && line.contains(" ")
		{
			println(line)
		}
	}

	os.execute("rm document.xml")
}