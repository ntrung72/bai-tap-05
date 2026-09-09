package vn.iotstar.service;

import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class StorageService {
    private final Path root;
    public StorageService(@Value("${shop.upload-dir}") String path) {
        root=Paths.get(path).toAbsolutePath().normalize();
    }
    public String save(MultipartFile file,String folder) throws IOException {
        if(file==null||file.isEmpty())return null;
        String original=Paths.get(file.getOriginalFilename()==null?"image":file.getOriginalFilename()).getFileName().toString();
        int dot=original.lastIndexOf('.');
        String ext=dot>=0?original.substring(dot):"";
        Path dir=root.resolve(folder);
        Files.createDirectories(dir);
        String name=UUID.randomUUID()+ext.toLowerCase();
        Files.copy(file.getInputStream(),dir.resolve(name),StandardCopyOption.REPLACE_EXISTING);
        return folder+"/"+name;
    }
    public void delete(String relative) {
        if(relative==null||relative.isBlank())return;
        try {
            Path p=root.resolve(relative).normalize();
            if(p.startsWith(root))Files.deleteIfExists(p);
        } catch(IOException ignored) {
        }
    }
    public Path resolveImage(String relative) throws IOException {
        Path p=root.resolve(relative.replace('\\','/')).normalize();
        if(!p.startsWith(root)||!Files.isRegularFile(p))throw new NoSuchFileException(relative);
        String first=root.relativize(p).getName(0).toString();
        if(!first.equals("product")&&!first.equals("category")&&!first.equals("avatar"))throw new AccessDeniedException(relative);
        return p;
    }
}
