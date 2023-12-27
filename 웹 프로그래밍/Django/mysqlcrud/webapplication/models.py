from django.db import models

# Create your models here.

class item(models.Model):
    itemid = models.CharField(max_length=50, primary_key=True)
    itemname = models.CharField(max_length= 100)
    price = models.IntegerField()
    description = models.CharField(max_length=100)
    pictureid = models.CharField(max_length=100)