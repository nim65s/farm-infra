<script lang="ts">
  import {
    getTodos,
    createTodo,
    updateTodo,
    deleteTodo,
    type Todo
  } from "./api";

  let todos: Todo[] = $state([]);
  let text = $state("");

  async function load() {
    todos = await getTodos();
  }

  async function add() {
    if (text.trim().length === 0) return;
    await createTodo(text);
    text = "";
    await load();
  }

  async function toggle(todo: Todo) {
    await updateTodo(todo.id, !todo.done);
    await load();
  }

  async function remove(id: number) {
    await deleteTodo(id);
    await load();
  }

  load();
</script>

<h1>Todo List</h1>

<input
  bind:value={text}
  onkeydown={(e) => e.key === "Enter" && add()}
/>
<button onclick={add}>Add</button>

<ul>
  {#each todos as todo}
    <li>
      <input
        type="checkbox"
        checked={todo.done}
        onchange={() => toggle(todo)}
      />
      {todo.description}
      <button onclick={() => remove(todo.id)}>❌</button>
    </li>
  {/each}
</ul>

<style>
  ul {
    text-align: left;
  }
</style>
