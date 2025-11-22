from django.db import models


class Todo(models.Model):
    done = models.BooleanField(default=False)
    description = models.TextField()

    def __str__(self):
        return f"[{'x' if self.done else ' '}] {self.description}"
