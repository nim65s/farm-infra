from ninja import NinjaAPI, ModelSchema
from ninja.errors import HttpError

from .models import Todo

api = NinjaAPI()


class TodoSchema(ModelSchema):
    class Meta:
        model = Todo
        fields = "__all__"


class TodoCreateSchema(ModelSchema):
    class Meta:
        model = Todo
        fields = ["description"]


class TodoUpdateSchema(ModelSchema):
    class Meta:
        model = Todo
        fields = ["done"]


@api.get("/todos", response=list[TodoSchema])
def list_todos(request):
    return Todo.objects.all().order_by("id")


@api.post("/todos", response=TodoSchema)
def create_todo(request, payload: TodoCreateSchema):
    todo = Todo(**payload.dict())
    todo.save()
    return todo


@api.put("/todos/{id}", response=TodoSchema)
def update_todo(request, id: int, payload: TodoUpdateSchema):
    try:
        todo = Todo.objects.get(id=id)
    except Todo.DoesNotExist:
        raise HttpError(404, "Todo not found")

    todo.done = payload.done
    todo.save()

    return todo


@api.delete("/todos/{id}")
def delete_todo(request, id: int):
    try:
        todo = Todo.objects.get(id=id)
    except Todo.DoesNotExist:
        raise HttpError(404, "Todo not found")

    todo.delete()
    return {"success": True}
