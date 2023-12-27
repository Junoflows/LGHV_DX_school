from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.

# 요청을 처리하는 함수의 매개변수는 request
# request 객체 안에는 클라이언트에 대한 정보가 저장되어 있음
def index(request):
    print(dir(request))
    return HttpResponse("<p>Hi django</p>")

def display(request):
    return render(request, 'display.html')

def page(request):
    return render(request, 'page.html')

def template(request):
    msg = 'hello template'
    person = {'name' : 'juno','age' : 25}
    # html에 데이터를 전송하고자 하면
    # 3번째 매개변수에 딕셔너리를 만들어서
    # 데이터 이름과 데이터를 기재
    return render(request, 'template1.html', {'msg' : msg, 'person' : person})

def template1(request):
    age = 54

    data = ['Stack', 'Queue', 'Deque', 'LinkedList', 'Tree', 'Graph', 'Array']

    return render(request, 'template1.html', {'age' : age, 'data' : data})