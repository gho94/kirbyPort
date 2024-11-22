const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

app.use(express.static("public"));


const users = {}; // 사용자 정보를 저장할 객체

io.on("connection", (socket) => {
    console.log(`User connected: ${socket.id}`);

    // 사용자 이름 등록
    socket.on("register", (userName) => {
        users[socket.id] = userName; // 사용자 이름을 socket.id에 매핑
        console.log(`User registered: ${userName}`);
    });

    // 메시지 전송 이벤트 처리
    socket.on("chat message", (data) => {
        console.log("Received raw message:", data);

        const senderName = users[socket.id] || "Anonymous"; // 등록된 이름 또는 기본값 Anonymous
        const message = data.text || "No message text";

        console.log(`${senderName} sent a message: ${message}`);

        // 모든 클라이언트에게 메시지와 보낸 사람의 이름 전송
        io.emit("chat message", { senderName, message, senderId: socket.id });
    });

    // 사용자 연결 해제 처리
    socket.on("disconnect", () => {
        console.log(`User disconnected: ${users[socket.id] || socket.id}`);
        delete users[socket.id]; // 연결 해제된 사용자의 정보 삭제
    });
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});