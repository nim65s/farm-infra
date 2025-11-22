<script lang="ts">
  import {
    getTodos,
    createTodo,
    updateTodo,
    deleteTodo,
    type Todo
  } from "./lib/api";

  let todos: Todo[] = [];
  let text = "";

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
  on:keydown={(e) => e.key === "Enter" && add()}
/>
<button on:click={add}>Add</button>

<ul>
  {#each todos as todo}
    <li>
      <input
        type="checkbox"
        checked={todo.done}
        on:change={() => toggle(todo)}
      />
      {todo.description}
      <button on:click={() => remove(todo.id)}>❌</button>
    </li>
  {/each}
</ul>

<style>
  ul {
    text-align: left;
  }
</style>
