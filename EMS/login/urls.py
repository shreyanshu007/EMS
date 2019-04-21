"""EMS URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='LoginPage'),
    path('postlogin/', views.postlogin, name='postlogin'),
    path('role/', views.role, name='role'),
    path('pay_slip/', views.pay_slip, name='pay_slip'),
    path('old_leaves/', views.old_leaves, name='old_leaves'),
    path('new_leaves/', views.new_leaves, name='new_leaves'),
    path('leaves/', views.leaves, name='leaves'),
    path('logout/', views.logout, name='logout')


]
