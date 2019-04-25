from django.shortcuts import render
from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.db import connection



def faculty(request):
	with connection.cursor() as cursor:
		cursor.execute('select * from person where email = %s;', [request.session['username']])
		for row in cursor.fetchall():
			params = {'left_leave': row[5]}
	if 'username' in request.session:
		return render(request, 'role/faculty.html', params)
	else:
		return HttpResponseRedirect('/login/')

def pay_slip(request):
	if 'username' in request.session:
		return render(request, 'role/pay_slip.html')
	else:
		return HttpResponseRedirect('/login/')

def old_leaves(request):
	if 'username' in request.session:
		return render(request, 'role/old_leaves.html')
	else:
		return HttpResponseRedirect('/login/')

def new_leaves(request):
	if 'username' in request.session:
		return render(request, 'role/new_leaves.html')
	else:
		return HttpResponseRedirect('/login/')

def leaves(request):
	if 'username' in request.session:
		return render(request, 'role/leaves.html')
	else:
		return HttpResponseRedirect('/login/')
