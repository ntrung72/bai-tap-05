package vn.iotstar.util;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validator;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.web.multipart.MultipartFile;

public final class ValidationUtils {
    private ValidationUtils() {
    }
    public static <T> Map<String,String> properties(Validator validator,T bean,String... names) {
        Map<String,String> out=new LinkedHashMap<>();
        for(String n:names)for(ConstraintViolation<T> v:validator.validateProperty(bean,n))out.putIfAbsent(n,v.getMessage());
        return out;
    }
    public static String imageError(MultipartFile file,long max) {
        if(file==null||file.isEmpty())return null;
        if(file.getSize()>max)return "Ảnh vượt quá kích thước cho phép "+(max/1024/1024)+" MB.";
        String type=file.getContentType();
        String name=file.getOriginalFilename()==null?"":file.getOriginalFilename().toLowerCase();
        if(
            type==null
                ||!type.toLowerCase().startsWith("image/")
                ||!(
                    name.endsWith(".jpg")
                        ||name.endsWith(".jpeg")
                        ||name.endsWith(".png")
                        ||name.endsWith(".gif")
                        ||name.endsWith(".webp")
                )
        )return "Chỉ chấp nhận ảnh JPG, JPEG, PNG, GIF hoặc WEBP.";
        return null;
    }
}
