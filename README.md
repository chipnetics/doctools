# Doctools - Document Analytics

Doctools are a collection of utilities for extracting plain-text from proprietary Microsoft Doc/Docx files; such that the resulting plain-text output can be used for.

* Diff operations (finding what has changed) - useful when tracking was not turned on in Word.
* Grepping / regex; and joining with other data sets 
* Natural language processing - for instance, text sentiment analysis.
* Verb / adjective / noun classification.
* General analytics such as word counts, longest sentence, etc.

This utility can be ran manually, or integrated into an automated-process/work-flow.  In general these utilities follow the [UNIX philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) much as possible.

# Project Motivation

There are a plethora of solutions for converting MS Doc/Docx to plain-text - however when you remove all those that are GUI based, remove installer-based solutions, remove non-compiled solutions (i.e. Python script), and remove (slow) COM-based solutions; the list suddenly is very small.  Compounded further that the remaining solutions are either Windows or Linux utilities; *but  not both*.

Finally, for the remaining few solutions that may exist, they generally don't prepare the data for natural language processing or text analytics.  Alas, this solution is also **very fast** as it directly extracts the underlying XML from the document and uses a multitude of regular expressions to clean & prepare the resulting text file for anlaytics.

# Work in Progress

This repository is generally work in progress.  While it functions there is room for improvement.  Currently is what this is **not** is a 1:1 Doc/Docx to plain-text converter.  In particular, the data is transformed such that each sentence is extracted onto a separate line break so that it can be used in analytics with *incredible ease*.  

Some basic string replacement takes place to facilitate this clearly in a way that won't confuse NLP engines (such as Google Cloud). One example is that ellipsis (...) will be replaced with ("such as,").  This is done as some 3rd party tools will (/may) mistake this for sentence breaks. Other immediate examples are "etc.", or roman numeral bullets (iii., iv., v.).

Any of these replacements will not affect the original meaning of the document however.


# Pre-Compiled Binaries

Binaries for Windows and Linux have been pre-compiled and can be found in the 'bin' folder. Or in the "Releases" section in GitHub.

With git, you can download all the latest source and binaries with `git clone https://github.com/chipnetics/doctools`

Alternatively, if you don't have git installed:

1. Download the latest release [here](https://github.com/chipnetics/doctools/releases)
2. Unzip to a local directory.
3. Navigate to 'bin' directory for executables.

# Compiling from Source

Utilities are written in the V programming language and will compile under Windows, Linux, and MacOS.

V is syntactically similar to Go, while equally fast as C.  You can read about V [here](https://vlang.io/).

After installing the [latest V compiler](https://github.com/vlang/v/releases/), it's as easy as executing the below.  _Be sure that the V compiler root directory is part of your PATH environment._

```
git clone https://github.com/chipnetics/doctools
cd src
v doc2txt.v
v txt2nlp.v
```
Alternatively, if you don't have git installed:

1. Download the bundled source [here](https://github.com/chipnetics/pval/archive/refs/heads/main.zip)
2. Unzip to a local directory
3. Navigate to src directory and run `v doc2txt.v` or `v txt2nlp.v`

Please see the [V language documentation](https://github.com/vlang/v/blob/master/doc/docs.md) for further help if required.

# Running Optional Command Line Arguments

For Windows users, if you want to pass optional command line arguments to an executable:

1. Navigate to the directory of the utility.
2. In the navigation (file-path) bar of Windows Explorer type "cmd" and hit enter to get a command prompt.
4. Type the name of the exe along with the optional argument (i.e. `doc2txt.exe --help` ).

For Linux users, command line arguments can of course be passed through your favourite shell terminal.

# Viewing Large Files

As an aside, the author recommends the excellent tool _EmEditor_ by Emurasoft for manually editing or viewing large text-based files for data science & analytics. Check out the tool [here](https://www.emeditor.com/).  _EmEditor_ is paid software but well worth the investment to increase effeciency.

# Examples

## **doc2txt** Converting Microsoft Docx to plain text for analytics

> NB: Output is to standard output (stdout), so use file redirection to write to file.

```
Options:
  -f, --doc <string>        specify the .doc file for parsing
  -h, --help                display this help and exit
  --version                 output version information and exit
```

Windows: `doc2txt.exe -f ../test/casestudy.docx > casestudy.txt`

Linux: `./doc2txt -f ../test/casestudy.docx > casestudy.txt`

*Sample output:*
| Sentence        |
| --------------------- |
ECONOMICS TECHNICAL NOTE.
Developing Conservation Case Studies for Decision-making.
Lynn Knight, ENTSC Economist.
Case studies or “Producer Experiences” are actual stories developed to present social, economic and environmental information on the conservation effects of implementing NRCS conservation practices.
Typically, field conservationists will make observations of conservation treatments applied by one or more land user(s) and record the effects.
Case study information may also be available from conservation field trials, Conservation Innovation Grant projects, university research plots or other field demonstration sites.
Case studies are a tool to document producer experiences, and a practical method for improving our planning, prioritizing assistance, and reaching out to new agricultural producers.


## **txt2nlp** Performing NLP (text sentiment analysis) on plain text file
> NB: Currently the *Google Cloud Natural Language*  API is supported.  You must have an active licence to use this utility. See https://cloud.google.com/natural-language.

> Your licence key should be stored on the first line of a plain text file. In the example below the API key is in the file "key.txt".  Be careful to not share your key - *future versions of the utility will encrypt the key*.

```
Options:
  -f, --txt <string>        specify the plain text file for parsing
  -k, --key <string>        specify the API licence key file
  -h, --help                display this help and exit
  --version                 output version information and exit
```

Windows: `txt2nlp.exe -f casestudy.txt -k key.txt > casestudy_sentiment.txt`

Linux: `./txt2nlp -f casestudy.txt -k key.txt > casestudy_sentiment.txt`

*Sample output:*

The output is of the text sentiment (sorted by order of magnitude), and the sentence anlayzed.

| Sentiment      | Sentence |
| ----------- | ----------- |
0.9	| Thus, recommendations for treatments are more credible because of a greater “product” knowledge and understanding.
0.9	|These insights will provide knowledgeable outcomes experienced by area farmers.
0.9	|Another advantage over the third approach, the data from “before and after” or “with and without” treatment helps to assure that all important issues and planning steps have been followed.
0.9	|Photographs and quotes from the producer are also helpful.
0.9	|A cooperative, knowledgeable farmer is one of the most important elements for a successful case study.
0.9	|Easy to read, especially for those that are not comfortable with economics or data.
0.9	|These experiences provide a practical source of information that shows how a prescribed treatment can work.
0.8	|The information enables planners with various levels of experience to have access to previous institutional knowledge.
0.8	|Case Studies will also help build a permanent record of treatment results that are very useful for selling conservation and that won’t disappear as employees retire or transfer.
0.8	|Answering these questions will help develop a strategic view of the area and will direct efforts to situations where the needs and opportunities are greatest.
0.8	|If the targeted land users do not feel the subject farm or treatments are applicable, they will not look to it as a reference or guide.
0.8	|Lacks detail behind the assumptions.
0.8	|Relatively quick and easy to document “before” and “after” effects, typically 1-2 pages.
0.8	|Lack of control in the benchmark situation or other variables for comparison.
0.7	|Interpreting specific changes attributable to conservation treatments with this method can be misleading due to the fact that important considerations may not be discussed.
