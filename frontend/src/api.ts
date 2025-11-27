export interface Todo {
  id: number;
  done: boolean;
  description: string;
}

const API = "http://localhost:8000/api/todos";

export async function getTodos(): Promise<Todo[]> {
  const r = await fetch(API);
  return r.json();
}

export async function createTodo(description: string): Promise<void> {
  await fetch(API, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ description }),
  });
}

export async function updateTodo(id: number, done: boolean): Promise<void> {
  await fetch(`${API}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ done }),
  });
}

export async function deleteTodo(id: number): Promise<void> {
  await fetch(`${API}/${id}`, { method: "DELETE" });
}

