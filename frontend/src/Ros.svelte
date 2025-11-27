<script lang="ts">
  let { instance } = $props();

  const proto = window.location.protocol === "https:" ? "wss:" : "ws:";
  const host = window.location.host;
  const ws = new WebSocket(`${proto}//${host}/ws/${instance}`);

  let messages: string[] = $state([]);

  ws.onopen = () => {
      ws.send(JSON.stringify({ op: "subscribe", topic: "/chatter" }));
  };

  ws.onmessage = (ev) => {
      const msg = typeof ev.data === "string" ? ev.data : JSON.stringify(ev.data);
      messages = [...messages, msg].slice(-5);
  };
</script>

{#each messages as m}
    <pre>{m}</pre>
{/each}
