from django.shortcuts import render
from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.db import connection


# if 'username' in request.session:


# Create your views here.
def index(request):
	return render(request, 'login/index.html')

def logout(request):
	if request.session.has_key('username'):
		del request.session['username']
		request.session.flush()
	return render(request, 'login/index.html')



def postlogin(request):
	email = request.POST.get('emailid', 'default')
	password = request.POST.get('password', 'default')

	with connection.cursor() as cursor:
		cursor.execute('select * from person where email = %s;', [email])

		# m = Member.objects.get(username=request.POST['username'])
		for row in cursor.fetchall():
			# print(password, " ", row[1] , " ", email)
			if password == row[3]:
				request.session['username'] = email
				return HttpResponseRedirect('/role/faculty/')

	return HttpResponseRedirect('/login/')








# return HttpResponseRedirect('/thanks/')