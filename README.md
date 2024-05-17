> [!CAUTION]
>CEF is generally good, but it's significantly constrained by MTA due to the lack of GPU rendering support. This limitation affects the performance of larger applications and 2D/3D rendering, often resulting in low FPS in animations, causing them to stutter when many elements are displayed at once.

>Additionally, there are compatibility problems for users with older PCs. CEF might crash frequently or fail to run altogether on these systems. However, it's not a major concern since very few people are still using outdated systems like Windows 7.

</br>
</br>

> [!NOTE]
>We've prepared technical documentation for our project so you can take a peek under the hood of our game. We've implemented some unconventional solutions, so we've created this documentation to provide a closer look at our technological choices and their implementation. In short, we'll discuss the technologies we use and explain why we decided to use them. Ready for an adventure into the depths of the code? Let's dive in!

</br>
</br>

<h2><b>UI Design in the Game and Its Performance</b></h1>

What's this whole CEF thing anyway? CEF is a crucial element of our environment that allows us to integrate a full-fledged web browser directly into the game server. One of the biggest advantages of CEF is that it utilizes all CPU cores, enabling parallel rendering and data processing. So why did we choose to use CEF instead of traditional methods like CEGUI or dx? Unlike traditional solutions, which are limited to using a single core, CEF provides much better scalability and performance. As a result, our server can handle even the most demanding game scenarios without sacrificing smoothness or performance. In short - your FPS will be quite powerful 🙂

<h2><b>How is the entire appearance of the game server created?</b></h1>

The answer is simple! We use a ready-made design of 'blocks', we just arrange it xD. Here's a bit more gibberish:
Material-UI (MUI) is a component library that is an integral part of our user interface (UI). It is based on React.js, which we use for dynamically rendering interface components in CEF. Thanks to React.js, our application runs smoothly and responsively even with a large number of user interactions. Additionally, Material-UI provides high-quality aesthetic components, allowing us to quickly and efficiently create new interface elements.
At the same time, we want our work to be efficient and not cause too many problems, so TypeScript comes to our aid.
The benefits of using TypeScript in our project:
Adding static typing to JavaScript increases code safety and readability.
TypeScript automatically checks most errors during compilation, ensuring that everything is okay.
Code clarity makes both writing and developing it in the future easier, resulting in higher efficiency and faster work pace.
By using TypeScript, our code becomes more transparent and error-resistant, significantly facilitating the process of its creation and further development. By introducing static typing, TypeScript allows us to precisely specify the data types used in our code, eliminating many potential errors related to type inconsistencies. This additional level of control when writing code translates into greater confidence in its correctness, which in turn contributes to the increased stability and reliability of our application. As a result, we have greater confidence that our code works as expected and is resistant to various failures or unforeseen situations, which is a significant advantage of our project.

<h2><b>How does our game server communication look like?</b></h1>

We decided to use an unconventional solution to split the server into two parts, one remains in the game, it is a typical server in which we perform standard operations requiring the use of MTA:SA API, on the other hand, we use REST API, i.e., an external server in which we perform operations that do not need to be done in the game server.

<h2><b>But what exactly is this whole REST API?</b></h1>

REST API enables communication between the MTA:SA server and external servers and applications. This allows our server to exchange data with other systems in a flexible and efficient manner. Moreover, using REST API allows us to offload our main MTA:SA server by moving some operations to external servers, resulting in better performance and stability of the entire game environment.

<h2><b>The entire communication in the game looks as follows:</b></h1>

<li>The client and Chromium Embedded Framework (CEF) establish a harmonious connection, enabling smooth interaction in the game.</li>
<li>In the case of server connection with CEF, data first passes through the client and then is transferred to CEF.</li>
<li>Additionally, the server also connects to the REST API, enabling integration with external servers and applications, as well as data exchange in both directions.</li>

</br>

Technologies such as CEF, React, Material-UI, TypeScript, and REST API are integral elements of our RP server on MTA:SA. Thanks to them, our game environment not only runs smoothly and efficiently but also offers a wide range of features and possibilities that make players' experience unforgettable. We hope this technical documentation will help you better understand how these technologies work and what benefits they bring to our server.

<h2><b>Sample CEF Data Transfer Code - Client:</b></h1>
<img src='https://i.imgur.com/joF5Hkr.png'/>
