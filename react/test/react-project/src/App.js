import { useEffect, useState } from "react";

function App() {
  const [text, setText] = useState("");

  const { API_URL, TEXT } = window.wingEnv;

  useEffect(() => {
    fetch(API_URL).then((response) => {
      response.text().then((data) => {
        setText(data);
      })
    });
  }, []);

  return (
    <div className="App">
      <p>TEXT: {TEXT}</p>
      <p>FROM API: {text}</p>
    </div>
  );
}

export default App;
