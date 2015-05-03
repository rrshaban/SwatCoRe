#import json
#from lxml import html
#import requests

#page = requests.get('http://www.swarthmore.edu/college-catalog/faculty-and-other-instructional-staff')
#tree = html.fromstring(page.text)
#profName = tree.xpath('//div[@class="content"]/text()')
#print profName
import urllib2
import HTMLParser
import re
import json
import lxml.html
from lxml.html.clean import Cleaner

url = 'http://www.swarthmore.edu/college-catalog/faculty-and-other-instructional-staff'
sock = urllib2.urlopen(url)
html = sock.read()
sock.close()

full_tree=lxml.html.fromstring(html)
profs = full_tree.xpath('//div[@class="content"]/p/strong/text()')
data = json.dumps(profs)

prof_dict = []
#other = []
for prof in profs:
	# remove commas and extra spaces from professor names
	name = ''
	for c in prof:
		if c == ',' or c == ', ':
			pass
		else:
			name += c
	if name[-1] == ' ':
		name = name[:-1]
	if name == '':
		continue
	namel = name.split(" ")
	
	# Store professor names in a dictionary with the form:
	#	'Professor Name' : 'Name, P'
	# so we can easily match the value to the existing database

	if len(namel) == 2: 
		prof_dict.append({'name': name, 'key':(namel[1] + ', ' + namel[0][0])})
	if len(namel) == 3:
		if '.' in namel[1]:
			prof_dict.append({'name':name, 'key':(namel[2] + ', ' + namel[0][0])}) 
	# use this to check for names that need to be inserted manually
	#	if len(namel) > 3:
	#		other.append(name)
	#	if other != []:
	#		print other
	# This was the only one that showed up in our courses as of spring 2015
	if namel[0] == 'Robinson' and namel[2] == 'Hollister':
		prof_dict.append({'name':'Robinson Hollister', 'key':('Hollister, R')})

with open("professors.json", 'w') as outfile:
	json.dump(prof_dict, outfile)
