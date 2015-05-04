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

	name = prof.split(',')[0]

	namel = name.split(" ")
	if len(namel) < 2 or namel[0] == '':
		continue
	
	# Store professor names in a dictionary with the form:
	#	'Professor Name' : 'Name, P'
	# so we can easily match the value to the existing database
	print name, namel
	prof_dict.append({'name': name, 'key':(namel[-1] + ', ' + namel[0][0])})

	# if len(namel) == 3:
	# 	if '.' in namel[1]:
	# 		prof_dict.append({'name':name, 'key':(namel[2] + ', ' + namel[0][0])}) 
	# use this to check for names that need to be inserted manually
	#	if len(namel) > 3:
	#		other.append(name)
	#	if other != []:
	#		print other
	# This was the only one that showed up in our courses as of spring 2015
	if namel[0] == 'Robinson' and namel[2] == 'Hollister':
		prof_dict.append({'name':'Robinson Hollister', 'key':('Hollister, R')})
	
	prof_dict.append({'name': 'Isaac Akrong', 'key': 'Akrong, I'})
	prof_dict.append({'name': "Sa'ed Atshan", 'key': 'Atshan, S'})
	prof_dict.append({'name': 'Ute Bettray', 'key': 'Bettray, U'})
	prof_dict.append({'name': 'Syon Bhanot', 'key': 'Bhanot, S'})
	prof_dict.append({'name': 'Adam Bisno', 'key': 'Bisno, A'})
	prof_dict.append({'name': 'Jennifer Bradley', 'key': 'Bradley, J'})
	prof_dict.append({'name': 'Elaine Brenneman', 'key': 'Brenneman, E'})
	prof_dict.append({'name': 'Elayne Browne', 'key': 'Browne, E'})
	prof_dict.append({'name': 'Vera Brusentsev', 'key': 'Brusentsev, V'})
	prof_dict.append({'name': 'Nesrine Chahine', 'key': 'Chahine, N'})
	prof_dict.append({'name': 'Julia Chindemi Vila', 'key': 'Chindemi Vila, J'})
	prof_dict.append({'name': 'Jennifer Chipman Bloom', 'key': 'Chipman Bloom, J'})
	prof_dict.append({'name': 'Denise Crossan', 'key': 'Crossan, D'})
	prof_dict.append({'name': 'Kathryne Daniel', 'key': 'Daniel, K'})
	prof_dict.append({'name': 'Shiva Das', 'key': 'Das, S'})
	prof_dict.append({'name': 'Desiree Diaz', 'key': 'Diaz, D'}) # TODO: This should have accents
	prof_dict.append({'name': 'Maiheng Dietrich', 'key': 'Dietrich, M'})
	prof_dict.append({'name': 'Erica Dobbs', 'key': 'Dobbs, E'})
	prof_dict.append({'name': 'Matthew Feliz', 'key': 'Feliz, M'})
	prof_dict.append({'name': 'Noemi Fernandez', 'key': 'Fernandez, N'})
	prof_dict.append({'name': 'Adrian Gras-Velazquez', 'key': 'Gras-Velazquez'})
	prof_dict.append({'name': 'Richard Hamberger', 'key': 'Hamberger, R'})
	prof_dict.append({'name': 'David Harrison', 'key': 'Harrison, D'})
	prof_dict.append({'name': 'Alexander Hazanov', 'key': 'Hazanov, A'})
	prof_dict.append({'name': 'Sarah Hiebert Burch', 'key': 'Hiebert Burch, S'})
	prof_dict.append({'name': 'Eric Hoffman', 'key': 'Hoffman, E'})
	prof_dict.append({'name': 'Alba Holmes', 'key': 'Holmes, A'})
	prof_dict.append({'name': 'Katharine Javian', 'key': 'Javian, K'})
	prof_dict.append({'name': 'Sanjeev Khanna', 'key': 'Khanna, S'})
	prof_dict.append({'name': 'Jeffrey Knerr', 'key': 'Knerr, J'})
	prof_dict.append({'name': 'Kathey Krannebitter', 'key': 'Krannebitter, K'})
	prof_dict.append({'name': 'Adam Lammert', 'key': 'Lammert, A'})
	prof_dict.append({'name': 'Thomas Limouze', 'key': 'Limouze, T'})
	prof_dict.append({'name': 'Hans Ludemann', 'key': 'Ludemann, H'})
	prof_dict.append({'name': 'Jasmina Lukic', 'key': 'Lukic, J'})
	prof_dict.append({'name': 'Adrienne Mackey', 'key': 'Mackey, A'})
	prof_dict.append({'name': 'Rebecca Malcolm-Naib', 'key': 'Malcolm-Naib, R'})
	prof_dict.append({'name': 'Shervin Malekzadeh', 'key': 'Malekzadeh, S'})
	prof_dict.append({'name': 'Luciano Martinez', 'key': 'Martinez, L'})
	prof_dict.append({'name': 'Braulio Munoz', 'key': 'Munoz, B'})
	prof_dict.append({'name': 'Joseph Nelson', 'key': 'Nelson, J'})
	prof_dict.append({'name': 'Andrew Neu', 'key': 'Neu, C'})
	prof_dict.append({'name': 'Grace Ngai', 'key': 'Ngai, G'})
	prof_dict.append({'name': 'Elizabeth Nichols', 'key': 'Nichols, E'})
	prof_dict.append({'name': 'Jocelyne Noveral', 'key': 'Noveral, J'})
	prof_dict.append({'name': 'Jeannine Osayande', 'key': 'Osayande, J'})
	prof_dict.append({'name': 'Niel Patterson', 'key': 'Patterson, N'})
	prof_dict.append({'name': 'Joe Gibbs Politz', 'key': 'Pilitz, J'})
	prof_dict.append({'name': 'Idan Porges', 'key': 'Porges, I'})
	prof_dict.append({'name': 'Bob Rehak', 'key': 'Rehak, R'})
	prof_dict.append({'name': 'Marc Remer', 'key': 'Remer, M'})
	prof_dict.append({'name': 'Ashley Ross', 'key': 'Ross, A'})
	prof_dict.append({'name': 'Olivia Sabee', 'key': 'Sabee, O'})
	prof_dict.append({'name': 'Margarita Sadovnikova', 'key': 'Sadovnikova'})
	prof_dict.append({'name': 'Mark Schneider', 'key': 'Schneider, M'})
	prof_dict.append({'name': 'Leisha Shaffer', 'key': 'Shaffer, L'})
	prof_dict.append({'name': 'Prakarsh Singh', 'key': 'Singh, P'})
	prof_dict.append({'name': 'Ameet Soni', 'key': 'Soni, A'})
	prof_dict.append({'name': 'Edward Steinberg', 'key': 'Steinberg, E'})
	prof_dict.append({'name': 'Kim Surkan', 'key': 'Surkan, K'})
	prof_dict.append({'name': 'Walter Thomason', 'key': 'Thomason, W'})
	prof_dict.append({'name': 'Scott Thomason', 'key': 'Thomason, S'})
	prof_dict.append({'name': 'Erin Todd Bronchetti', 'key': 'Todd Bronchetti, E'})
	prof_dict.append({'name': 'Jason Waterman', 'key': 'Waterman, J'})
	prof_dict.append({'name': 'Tara Webb', 'key': 'Webb, T'})
	prof_dict.append({'name': 'Douglass Wright', 'key': 'Wright, D'})
	prof_dict.append({'name': 'Rebecca Wright', 'key': 'Wright, R'})

with open("professors.json", 'w') as outfile:
	json.dump(prof_dict, outfile)
