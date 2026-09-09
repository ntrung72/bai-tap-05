package vn.iotstar.controller;

import java.io.IOException;
import java.nio.file.*;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.service.StorageService;

@RestController
public class ImageController {
    private final StorageService storage;
    public ImageController(StorageService storage) {
        this.storage=storage;
    }
    @GetMapping("/image")
    public ResponseEntity<Resource> image(@RequestParam("fname") String name) throws IOException {
        Path p=storage.resolveImage(name);
        String type=Files.probeContentType(p);
        if(type==null||!type.startsWith("image/"))return ResponseEntity.status(415).build();
        return ResponseEntity.ok().contentType(MediaType.parseMediaType(type)).body(new UrlResource(p.toUri()));
    }
    @ExceptionHandler( {
        NoSuchFileException.class,AccessDeniedException.class
    }
    ) public ResponseEntity<Void> missing(Exception e) {
        return ResponseEntity.notFound().build();
    }
}
