export interface RosFeed {
    ws: WebSocket;
    messages: string[];
    onMessage: (cb: (msgs: string[]) => void) => void;
}

export function createRosFeed(instance: string): RosFeed {
    const proto = window.location.protocol === "https:" ? "wss:" : "ws:";
    const host = window.location.host;
    const ws = new WebSocket(`${proto}//${host}/ws/${instance}`);
    let messages: string[] = $state([]);
    let listeners: Array<(msgs: string[]) => void> = $state([]);

    ws.onopen = () => {
        ws.send(JSON.stringify({ op: "subscribe", topic: "/chatter" }));
    };

    ws.onmessage = (ev) => {
        const msg = typeof ev.data === "string" ? ev.data : JSON.stringify(ev.data);
        messages = [...messages, msg].slice(-5);
        listeners.forEach(cb => cb(messages));
    };

    return {
        ws,
        get messages() {
            return messages;
        },
        onMessage(cb) {
            listeners.push(cb);
        }
    }
}

