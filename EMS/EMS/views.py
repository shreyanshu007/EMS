from django.shortcuts import render
from django.http import HttpResponse


def printing(request):
	return HttpResponse('chk')