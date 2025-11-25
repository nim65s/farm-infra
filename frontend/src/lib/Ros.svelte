<script lang="ts">
  import { createRosFeed } from "./ros";

  const salameche = createRosFeed("salameche");
  const carapuce = createRosFeed("carapuce");
  const bulbizarre = createRosFeed("bulbizarre");

  let msgsSal: string[] = [];
  let msgsCar: string[] = [];
  let msgsBul: string[] = [];

  salameche.onMessage(m => msgsSal = [...m]);
  carapuce.onMessage(m => msgsCar = [...m]);
  bulbizarre.onMessage(m => msgsBul = [...m]);
</script>

<h2>ROS</h2>

<h3>Salamèche</h3>
{#each msgsSal as m}
    <pre>{m}</pre>
{/each}

<h3>Carapuce</h3>
{#each msgsCar as m}
    <pre>{m}</pre>
{/each}

<h3>Bulbizarre</h3>
{#each msgsBul as m}
    <pre>{m}</pre>
{/each}
