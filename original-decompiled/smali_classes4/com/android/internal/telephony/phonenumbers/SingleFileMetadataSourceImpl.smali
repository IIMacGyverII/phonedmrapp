.class final Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;
.super Ljava/lang/Object;
.source "SingleFileMetadataSourceImpl.java"

# interfaces
.implements Lcom/android/internal/telephony/phonenumbers/MetadataSource;


# instance fields
.field private final metadataLoader:Lcom/android/internal/telephony/phonenumbers/MetadataLoader;

.field private final phoneNumberMetadataFileName:Ljava/lang/String;

.field private final phoneNumberMetadataRef:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "Lcom/android/internal/telephony/phonenumbers/MetadataManager$SingleFileMetadataMaps;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/phonenumbers/MetadataLoader;)V
    .locals 1

    const-string v0, "/com/android/internal/telephony/phonenumbers/data/SingleFilePhoneNumberMetadataProto"

    .line 45
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;-><init>(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/MetadataLoader;)V

    return-void
.end method

.method constructor <init>(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/MetadataLoader;)V
    .locals 1

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 33
    new-instance v0, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->phoneNumberMetadataRef:Ljava/util/concurrent/atomic/AtomicReference;

    .line 39
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->phoneNumberMetadataFileName:Ljava/lang/String;

    .line 40
    iput-object p2, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->metadataLoader:Lcom/android/internal/telephony/phonenumbers/MetadataLoader;

    return-void
.end method


# virtual methods
.method public getMetadataForNonGeographicalRegion(I)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 2

    .line 62
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->phoneNumberMetadataRef:Ljava/util/concurrent/atomic/AtomicReference;

    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->phoneNumberMetadataFileName:Ljava/lang/String;

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->metadataLoader:Lcom/android/internal/telephony/phonenumbers/MetadataLoader;

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getSingleFileMetadataMaps(Ljava/util/concurrent/atomic/AtomicReference;Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/MetadataLoader;)Lcom/android/internal/telephony/phonenumbers/MetadataManager$SingleFileMetadataMaps;

    move-result-object p0

    .line 63
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/MetadataManager$SingleFileMetadataMaps;->get(I)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p0

    return-object p0
.end method

.method public getMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 2

    .line 50
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->phoneNumberMetadataRef:Ljava/util/concurrent/atomic/AtomicReference;

    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->phoneNumberMetadataFileName:Ljava/lang/String;

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/SingleFileMetadataSourceImpl;->metadataLoader:Lcom/android/internal/telephony/phonenumbers/MetadataLoader;

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getSingleFileMetadataMaps(Ljava/util/concurrent/atomic/AtomicReference;Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/MetadataLoader;)Lcom/android/internal/telephony/phonenumbers/MetadataManager$SingleFileMetadataMaps;

    move-result-object p0

    .line 51
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/MetadataManager$SingleFileMetadataMaps;->get(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p0

    return-object p0
.end method
