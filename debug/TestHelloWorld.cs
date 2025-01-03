using System;

class HelloWorld
{
    public string greeting = "Hello, World!";

    public void SayHelloWorld()
    {
        Console.WriteLine(greeting);
    }

    static void Main()
    {
        HelloWorld helloWorldInstance = new HelloWorld();
        helloWorldInstance.SayHelloWorld();
    }
}
