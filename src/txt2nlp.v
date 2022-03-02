import net.http
import json
import os
import flag

// Sample CURL
// curl "https://language.googleapis.com/v1/documents:analyzeSentiment" -X POST -H "X-Goog-Api-Key: api_key" -H "Content-Type: application/json"   --data-binary @request.json

fn main()
{
	mut fp := flag.new_flag_parser(os.args)
    fp.application('txt2nlp')
	
    fp.version('v2022.03.02\nCopyright (c) 2022 jeffrey -at- ieee.org. All rights \
	reserved.\nUse of this source code (/program) is governed by an MIT \
	license,\nthat can be found in the LICENSE file.')

    fp.description('\nPerforms text sentiment analysis on plain txt file.\n\
	Uses the Google Cloud Natural Language API.\n\
	You -MUST- have an active API licence to use this utility.\n\
	This software will -NOT- make any changes to your txt files.')

    fp.skip_executable()

    mut txt_arg := fp.string('txt', `f`, "", 
								'specify the plain text file for parsing')
	mut key_arg := fp.string('key', `k`, "", 
								'specify the API licence key file')
								
										
	additional_args := fp.finalize() or {
        eprintln(err)	
        println(fp.usage())
        return
    }

	additional_args.join_lines()

	if txt_arg.len==0
	{
		eprintln("[ERROR] You must specify a plain text file for analysis.\nSee usage below.\n")
		println(fp.usage())
		exit(0)
		return
	}		

	if key_arg.len==0
	{
		eprintln("[ERROR] You must specify a file that contains the API licence key on the first line.\nSee usage below.\n")
		println(fp.usage())
		exit(0)
		return
	}	

	key_lines := os.read_lines(key_arg) or {panic(err)}	
	api_licence_key := key_lines[0]

	lines := os.read_lines(txt_arg) or {panic(err)}

	mut data_str := r'{"document":{"content": "'
	for line in lines
	{
		data_str += "$line  ".replace("\"","\\\"") // Google API expects two spaces after each sentence.
	}

	data_str += '","type": "PLAIN_TEXT"}}'

	result := http.fetch(
		url: "https://language.googleapis.com/v1/documents:analyzeSentiment",
		method: .post,
		data: data_str,
		header: http.new_custom_header_from_map({"X-Goog-Api-Key": api_licence_key,"Content-Type": "application/json"}) or { panic(err) }
	) or { panic(err) }

	mut ret := json.decode(ResNLP, result.text) or {
        eprintln('Failed to parse json')
        ResNLP{} 
    }

	mut nlp_arr := []NLPinternal{}

	for entry in ret.sentences
	{
		mut nlp_result := NLPinternal{}
		nlp_result.sentence = entry.text.content
		nlp_result.magnitude = entry.sentiment.magnitude
		nlp_arr << nlp_result
	}

	nlp_arr.sort(b.magnitude < a.magnitude)

	for entry in nlp_arr
	{
		println("${entry.magnitude:2.1f}\t${entry.sentence}")
	}
}

struct NLPinternal
{
	mut:
		sentence string
		magnitude f64
}

struct ResNLP
{
	sentences []Sentences [json:sentences]
}

struct Sentences
{
	text Text [json:text]
	sentiment Sentiment [json:sentiment]
}

struct Sentiment
{
	magnitude f64 [json:magnitude]
	score f64 [json:score]
}

struct Text
{
	content string [json:content]
}