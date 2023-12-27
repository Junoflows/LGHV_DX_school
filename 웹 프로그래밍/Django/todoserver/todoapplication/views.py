from django.shortcuts import render
from django.views import View

# Json 응답을 만들기 위해 import
from django.http import JsonResponse
from rest_framework import status

# 클래스의 get, psot, put, delete 메서드가 각 요청 방식을 처리
from .models import Todo

# 날짜를 사용하기 위해 import
import datetime
import json

from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator

@method_decorator(csrf_exempt, name = 'dispatch')
class Todoview(View):
    # get 요청
    def get(self, request):
        # 파라미터를 읽어오기
        # userid 가 없으면 None
        userid = request.GET.get('userid', None)
        if userid != None:
            todos = Todo.objects.filter(userid = userid)
        else:
            todos = Todo.objects.all()
        # JSON 응답 list라는 키로 검색된 데이터를 list로 전달
        return JsonResponse({'list' : list(todos.values())},
                            status = status.HTTP_200_OK)
    
    # post 요청
    def post(self, request):
        # 파라미터 읽기
        params = json.loads(request.body)
        userid = params["userid"]
        title = params['title']

        # 삽입할 객체를 생성
        todo = Todo()
        todo.userid = userid
        todo.title = title
        todo.done = False
        todo.moddate = datetime.datetime.today()

        # 데이터 삽입
        todo.save()

        # 삽입한 후 결과처리
        # 일반적으로 삽입한 데이터만 리턴 아니면
        # 전체 데이터 리턴하는 방식으로 구현
        todos = Todo.objects.filter(userid = userid)
        # JSON 응답 list 라는 키로 검색된 데이터를 list로 전달
        return JsonResponse({'list' : list(todos.values())},
                            status = status.HTTP_200_OK)
    
    def put(self, request):
        # 클라이언트의 파라미터 읽기
        params = json.loads(request.body)
        id = params['id']
        done = params['done']
        userid = params['userid']
        
        # 서버에서의 처리
        # 여기서 데이터베이스 작업 이외의 작업을 한다면 별도의 클래스를
        # 만들어서 처리한 후 리턴을 받아서 다음 작업을 수행
        # id에 해당하는 데이터를 찾아서 done 의 값을 수정
        todo = Todo.objects.get(id = id)
        todo.done = done
        todo.moddate = datetime.datetime.today()
        todo.save()

        # 응답 만들기
        # 삽입한 후 결과처리
        # 일반적으로 삽입한 데이터만 리턴 아니면
        # 전체 데이터 리턴하는 방식으로 구현
        todos = Todo.objects.filter(userid = userid)
        # JSON 응답 list 라는 키로 검색된 데이터를 list로 전달
        return JsonResponse({'list' : list(todos.values())},
                            status = status.HTTP_200_OK)
    
    def delete(self, request):
        # 파라미터 읽기
        params = json.loads(request.body)
        id = params["id"]
        userid = params["userid"]

        # 데이터 가져오기
        todo = Todo.objects.get(id = id)
        # 데이터 삭제
        todo.delete()

        todos = Todo.objects.filter(userid = userid)
        # JSON 응답 list 라는 키로 검색된 데이터를 list로 전달
        return JsonResponse({'list' : list(todos.values())},
                            status = status.HTTP_200_OK)