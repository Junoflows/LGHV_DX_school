from django.shortcuts import render
from webapplication.models import item
from django.http import HttpResponse

# Create your views here.
def index(request):
    # 전체 데이터 가져오기

    data = item.objects.all()
    return render(request, 'index.html', {'data' : data})

def detail(request, itemid):
    item = item.objects.get(itemid = itemid)
    return render(request, 'detail.html', {'item' : item})