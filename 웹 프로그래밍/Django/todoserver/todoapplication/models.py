from django.db import models

# Create your models here.
class Todo(models.Model):
    id = models.AutoField(primary_key=True) # auto_increment
    userid = models.CharField(max_length=100)
    title = models.CharField(max_length=100)
    done = models.BooleanField()
    regdate = models.DateTimeField(auto_now_add = True)
    moddate = models.DateTimeField()