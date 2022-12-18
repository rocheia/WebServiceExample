package us.zbits.ws.example;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1")
public class ExampleService {

    @GetMapping("/greet/{name}")
    private Mono<String> getGreeting(@PathVariable String name) {
        return Mono.just("Hello my friend " + name);
    }
}
