export const examples = [
  { id: 'session', text: 'shared browser session', title: '同一個登入狀態，讓幾個地方一起用。',
    body: '想像你進一棟辦公大樓，只要在入口換一次通行證。同一棟樓裡的不同房間，都認得這張證，不用每進一間就重新登入。',
    detail: '放在網站裡，就是多個頁面或服務共用同一個瀏覽器 session。實際怎麼共用，仍取決於 cookie 範圍、驗證方式和後端的設計。',
    example: '你在首頁登入，再打開 dashboard，仍然是登入狀態。兩個地方透過同一個 session 識別你。',
    note: 'Shared 指的是同一位使用者的登入狀態被共用，不是把你的帳號分享給別人。' },
  { id: 'race', text: 'race condition', title: '結果，取決於誰先跑完。',
    body: '兩個人同時看到冰箱裡還有最後一塊蛋糕，都以為自己可以拿。問題不在誰做錯，而是兩個動作沒有協調好先後順序。',
    detail: '程式裡，多個操作同時讀取或修改同一份資料，結果隨執行順序而變，就可能出現 race condition。',
    example: '庫存只剩一件，兩筆訂單同時讀到「還有一件」，最後卻各賣出一件。',
    note: '「同時發生」不一定就是問題；共用資料與操作順序影響結果，才是關鍵。' },
  { id: 'context', text: 'context compaction', title: '把長對話收成一張重點小抄。',
    body: '聊了很久，桌上的筆記越堆越多。與其把每張紙都攤開，不如整理一張小抄，留下目標、決定和還沒做完的事，再繼續往下聊。',
    detail: 'Agent 可以用濃縮後的內容取代一部分較早的上下文，讓接下來的推理仍有重要背景。各工具保留的內容和方式不一定相同。',
    example: '前面討論了很多版介面，小抄只保留「做本機原型、文字拖進空格、下方展開解釋」這些已經決定的事。',
    note: '小抄可能漏掉細節，因此它不等於完整保存了每一則原始訊息。' }
];

export function intake(value) {
  const text = String(value ?? '').replace(/\r\n?/g, '\n').replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]/g, '').trim();
  if (!text) throw new Error('先選一段文字，再把它拖進空格。');
  if (text.length > 40000) throw new Error('這段有點長。先選取 40,000 字元以內的一段文字。');
  return text;
}

export function explain(text) {
  return examples.find(item => text.toLowerCase().includes(item.text)) ?? {
    id: 'unknown', title: '這句收到了。下一步，就是把它說明白。',
    body: '這是互動原型，目前還沒有連接 AI，所以不會替這段文字編造解釋。你可以先感受拖放、展開原文和保存的流程。',
    detail: '試試下方的三個例子，它們有預先寫好的白話說明。正式版本會把你放進來的文字交給模型，並在上下文不足時請你補充。',
    example: null, note: '本頁不會將你拖入的文字傳送到任何伺服器。'
  };
}

export function markdown(original, reply) {
  return `# wdym?\n\n## 原文\n\n${original}\n\n## ${reply.title}\n\n${reply.body}\n\n${reply.detail}\n${reply.example ? `\n### 舉個例子\n\n${reply.example}\n` : ''}\n${reply.note}\n\n---\n互動原型：以上為示範內容，非即時 AI 回答。\n`;
}
