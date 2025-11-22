from ninja import NinjaAPI, ModelSchema

from .models import Todo

api = NinjaAPI()


class TodoSchema(ModelSchema):
    class Meta:
        model = Todo
        fields = "__all__"


@api.get("/todos", response=list[TodoSchema])
def list_todos(request):
    return Todo.objects.all()
