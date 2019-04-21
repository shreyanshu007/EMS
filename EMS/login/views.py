from django.shortcuts import render
from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.db import connection


# if 'username' in request.session:


# Create your views here.
def index(request):
	return render(request, 'login/index.html')

def role(request):
	with connection.cursor() as cursor:
		cursor.execute('select * from person where email = %s;', [request.session['username']])
		for row in cursor.fetchall():
			params = {'left_leave': row[5]}
	if 'username' in request.session:
		return render(request, 'login/role.html', params)
	else:
		return HttpResponseRedirect('/login/')

def pay_slip(request):
	if 'username' in request.session:
		return render(request, 'login/pay_slip.html')
	else:
		return HttpResponseRedirect('/login/')

def old_leaves(request):
	if 'username' in request.session:
		return render(request, 'login/old_leaves.html')
	else:
		return HttpResponseRedirect('/login/')

def new_leaves(request):
	if 'username' in request.session:
		return render(request, 'login/new_leaves.html')
	else:
		return HttpResponseRedirect('/login/')

def leaves(request):
	if 'username' in request.session:
		return render(request, 'login/leaves.html')
	else:
		return HttpResponseRedirect('/login/')



# def basic(request):
# 	if 'username' in request.session:
# 		return render(request, 'login/basic.html')
# 	else:
# 		return HttpResponseRedirect('/login/')



def logout(request):
	if request.session.has_key('username'):
		del request.session['username']
		request.session.flush()
	return render(request, 'login/index.html')



def postlogin(request):
	email = request.POST.get('emailid', 'default')
	password = request.POST.get('password', 'default')

	# params = {'email': email}
	# print (email)

	with connection.cursor() as cursor:
		cursor.execute('select * from person where email = %s;', [email])

		# m = Member.objects.get(username=request.POST['username'])
		for row in cursor.fetchall():
			# print(password, " ", row[1] , " ", email)
			if password == row[3]:
				request.session['username'] = email
				return HttpResponseRedirect('/login/role/')

	return HttpResponseRedirect('/login/')








# return HttpResponseRedirect('/thanks/')