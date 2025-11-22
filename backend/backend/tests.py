from django.test import TestCase

from .models import Todo


class BackendTests(TestCase):
    def test_todo(self):
        todo = Todo.objects.create(description="test")
        self.assertEqual(str(todo), "[ ] test")
        todo.done = True
        self.assertEqual(str(todo), "[x] test")
