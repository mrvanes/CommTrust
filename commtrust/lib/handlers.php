<?php
require_once '../lib/ga.php';

class empty_handler {
    private $id = "EMPTY";
    private $config = [];
    private $attributes = [];
    private $completed = false;
    private $source = "";

    function __construct($config) {
        $this->config = json_decode($config, true);
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return [ 'a' => 'empty' ];

    }

    function render_evidence($e) {
        return $e;
    }

    function get_card($proof, $config) {
        $r = $this->attributes;
        return $r;
    }

    function get_source() {
        return $this->source;

    }

    function start() {
        $this->attributes = ["a" => "b" ];
        $this->source = $this->id;
        $this->completed = true;
    }

    function clear($return_url) {
        $this->attributes = [];
        $this->completed = false;
    }

    function is_completed() {

        return $this->completed;

    }

}

class saml_handler {
    protected $id = "SAML";
    protected $config = [];
    protected $attributes = [];
    protected $sp = "";
    protected $idp = "";
    protected $session = "";
    protected $source = "";
    protected $completed = false;
    protected $card = [];

    function __construct($config) {
        $c = json_decode($config, true);
        $this->sp = $c['sp'];
        $this->idp = $c['idp'];
        $this->card = $c['card'];
        $this->session = new \SimpleSAML\Auth\Simple($c['sp']);
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return $this->attributes;

    }

    function render_evidence($e) {
        return $e;
    }

    function get_card($proof, $config) {
        $c = json_decode($config, true);
        $p = json_decode($proof, true);
        foreach($c['card'] as $a) {
            if (isset($p[$a])) $r[$a] = implode("; ", $p[$a]);
        }
        return $r;
    }

    function get_source() {
        return $this->source;

    }

    function start() {
        $this->session->requireAuth([
            'saml:idp' => $this->idp,
        ]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
        $this->attributes = $this->session->getAttributes();
        $this->source = $this->session->getAuthData('saml:sp:IdP');
        $this->completed = true;
    }

    function clear($return_url) {
        if (!$return_url) $return_url = $_SERVER['PHP_SELF'];
        $this->session->logout(['ReturnTo' => $return_url]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
    }

    function is_completed() {
        return $this->completed;
    }

}

class saml_cripple_handler extends saml_handler {
    protected $id = "SAML_***";

    function start() {
        $this->session->requireAuth([
            'saml:idp' => $this->idp,
        ]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
        $attributes = $this->session->getAttributes();
	foreach ($attributes as $attribute => $values) {
            foreach($values as $value) {
                $cripled[$attribute][] = substr($value, 0,3) . "*";
            }
	}
        $this->attributes = $cripled;
        $this->source = $this->session->getAuthData('saml:sp:IdP');
        $this->completed = true;
    }

}


class oidc_handler {
    protected $id = "OIDC";
    protected $config = [];
    protected $attributes = [];
    protected $rp = "";
    protected $op = "";
    protected $session = "";
    protected $source = "";
    protected $completed = false;
    protected $card = [];

    function __construct($config) {
        $c = json_decode($config, true);
        $this->rp = $c['rp'];
        $this->op = $c['op'];
        $this->card = $c['card'];
        $this->session = new \SimpleSAML\Auth\Simple($c['rp']);
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return $this->attributes;

    }

    function render_evidence($e) {
        return $e;
    }

    function get_card($proof, $config) {
        $c = json_decode($config, true);
        $p = json_decode($proof, true);
        foreach($c['card'] as $a) {
            if (isset($p[$a])) $r[$a] = implode("; ", $p[$a]);
        }
        return $r;
    }

    function get_source() {
        return $this->source;

    }

    function start() {
        echo "OP: " . print_r($this->op, true);
        $this->session->requireAuth([
            'openidconnect:op' => $this->op
        ]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
        $this->attributes = $this->session->getAttributes();
        $this->source = $this->op['client_id'];
        $this->completed = true;
    }

    function clear($return_url) {
        if (!$return_url) $return_url = $_SERVER['PHP_SELF'];
        $this->session->logout(['ReturnTo' => $return_url]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
    }

    function is_completed() {
        return $this->completed;
    }

}

class oidc_cripple_handler extends oidc_handler {
    protected $id = "OIDC_***";

    function start() {
        echo "OP: " . print_r($this->op, true);
        $this->session->requireAuth([
            'openidconnect:op' => $this->op
        ]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
        $attributes = $this->session->getAttributes();
	foreach ($attributes as $attribute => $values) {
            foreach($values as $value) {
                $cripled[$attribute][] = substr($value, 0,3) . "*";
            }
	}
        $this->attributes = $cripled;
        $this->source = $this->op['client_id'];
        $this->completed = true;
    }

}

class orcid_handler {
    protected $id = "ORCID";
    protected $config = [];
    protected $attributes = [];
    protected $rp = "";
    protected $session = "";
    protected $source = "";
    protected $completed = false;
    protected $card = [];

    function __construct($config) {
        $c = json_decode($config, true);
        $this->rp = $c['rp'];
        $this->card = $c['card'];
        $this->session = new \SimpleSAML\Auth\Simple($c['rp']);
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return $this->attributes;

    }

    function render_evidence($e) {
        return $e;
    }

    function get_card($proof, $config) {
        $c = json_decode($config, true);
        $p = json_decode($proof, true);
        foreach($c['card'] as $a) {
            if (isset($p[$a])) $r[$a] = implode("; ", $p[$a]);
        }
        return $r;
    }

    function get_source() {
        return $this->source;

    }

    function start() {
        $this->session->requireAuth();
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
        $this->attributes = $this->session->getAttributes();
        $this->source = $this->id;
        $this->completed = true;
    }

    function clear($return_url) {
        if (!$return_url) $return_url = $_SERVER['PHP_SELF'];
        $this->session->logout(['ReturnTo' => $return_url]);
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
    }

    function is_completed() {
        return $this->completed;
    }

}

class orcid_cripple_handler extends orcid_handler {
    protected $id = "ORCID_***";

    function start() {
        $this->session->requireAuth();
        \SimpleSAML\Session::getSessionFromRequest()->cleanup();
        $attributes = $this->session->getAttributes();
	foreach ($attributes as $attribute => $values) {
            foreach($values as $value) {
                $cripled[$attribute][] = substr($value, 0,3) . "*";
            }
	}
        $this->attributes = $cripled;
        $this->source = $this->id;
        $this->completed = true;
    }

}
class self_handler {
    private $id = "SELF";
    private $config = [];
    private $attributes = [];
    private $completed = false;
    private $source = "";
    private $card = [];
    private $inputs = [];

    function __construct($config) {
        $c = json_decode($config, true);
        $this->inputs = $c['inputs'];
        $this->card = $c['card'];
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return $this->attributes;

    }

    function render_evidence($e) {
        return $e;
    }

    function get_card($proof, $config) {
        $c = json_decode($config, true);
        $p = json_decode($proof, true);
        foreach($c['card'] as $a) {
            if (isset($p[$a])) $r[$a] = implode("; ", $p[$a]);
        }
        return $r;
    }

    function get_source() {
        return $this->source;

    }

    function start() {
        $self_attributes = restore('self:attributes', []);
        if (!$self_attributes) {
            remove('self:inputs', []);
            $inputs = restore('self:inputs', $this->inputs);
            header('Location: /self.php');
            exit;
        }
        $this->attributes = $self_attributes;
        $this->source = $this->id;
        $this->completed = true;
    }

    function clear($return_url) {
        $this->attributes = [];
        $this->completed = false;
        remove('self:attributes', []);
        remove('self:inputs', []);
        header('Location: ' . $return_url);
        exit;
    }

    function is_completed() {
        return $this->completed;

    }
}

class totp_handler {
    private $id = "TOTP";
    private $config = [];
    private $attributes = [];
    private $completed = false;
    private $source = "";
    private $card = [];

    function __construct($config) {
        $c = json_decode($config, true);
        $this->card = $c['card'];
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return $this->attributes;

    }

    function render_evidence($e) {
        $ga = new PHPGangsta_GoogleAuthenticator();
        if (isset($e['secret'])) {
            $e['totp'] = [$ga->getCode(implode("; ", $e['secret']))];
            $e['secret'] = ['*****'];
        }
        return $e;
    }

    function get_card($proof, $config) {
        $c = json_decode($config, true);
        $p = json_decode($proof, true);
        $ga = new PHPGangsta_GoogleAuthenticator();
        foreach($c['card'] as $a) {
            if ($a == 'secret') {
                $r['totp'] = $ga->getCode(implode("; ", $p[$a]));
//                 $r['secret'] = implode("; ", $p[$a]);
            } else  {
                if (isset($p[$a])) $r[$a] = implode("; ", $p[$a]);
            }
        }
        return $r;
    }

    function get_source() {
        return $this->source;
    }

    function start() {
        $totp_secret = restore('totp:secret', '');
        if (!$totp_secret) {
            header('Location: /totp.php');
            exit;
        }
        $this->attributes = ['secret' => [$totp_secret]];
        $this->source = $this->id;
        $this->completed = true;
    }

    function clear($return_url) {
        $this->attribtes = [];
        $this->completed = false;
        remove('totp:secret', '');
        header('Location: ' . $return_url);
        exit;
    }

    function is_completed() {
        return $this->completed;

    }
}

class readid_handler {
    private $id = "ReadID";
    private $config = "";
    private $sp = "";
    private $idp = "";
    private $session = "";
    private $attributes = "";
    private $source = "";
    private $completed = false;

    function __construct($config) {
        $c = json_decode($config, true);
//         $this->sp = $c->sp;
//         $this->idp = $c->idp;
//         $this->session = new \SimpleSAML\Auth\Simple($c->sp);
    }

    function get_id() {
        return $this->id;
    }

    function get_attributes() {
        return $this->attributes;

    }

    function render_evidence($e) {
        return $e;
    }

    function get_card($proof) {
        $p = json_decode($proof, true);
        if (isset($p['deviceInfo']['brand'])) $r['brand'] = $p['deviceInfo']['brand'];
        if (isset($p['deviceInfo']['model'])) $r['model'] = $p['deviceInfo']['model'];
        if (isset($p['documentContent']['nameOfHolder'])) $r['holder'] = $p['documentContent']['nameOfHolder'];
        return $r;
    }

    function get_source() {
        return $this->source;

    }

    function start() {
//         $this->session->requireAuth([
//             'saml:idp' => $this->idp,
//         ]);
        $this->attributes = json_decode($this->readid_reply, true);
        $this->source = "readid";
        $this->completed = true;
    }

    function clear($return_url) {
        header('Location: ' . $return_url);
        exit;
    }

    function is_completed() {
        return $this->completed;
    }

    private $readid_reply = '{
    "@odata.context": "https://ready.readid.com/odata/v1/ODataServlet/$metadata#Sessions/$entity",
    "app": {
        "appVersion": "3.6.4",
        "customerName": "ReadID Ready",
        "packageName": "com.readid.ready",
        "timestamp": 1584518365815
    },
    "chip": {
        "chipRead": true,
        "chipTypes": ["IsoDep", "NfcB"],
        "timestamp": 1584518365811
    },
    "clientId": "com.readid.ready",
    "consolidatedIdentityData": {
        "chipCloneDetection": "SUCCEEDED",
        "chipCloneDetectionSource": "CHIP",
        "chipCloneDetectionSourceName": "ReadID NFC",
        "chipVerification": "SUCCEEDED",
        "chipVerificationSource": "CHIP",
        "chipVerificationSourceName": "ReadID NFC",
        "creationDate": "2020-03-18T07:59:27.111Z",
        "dateOfBirth": "YYMMDD",
        "dateOfBirthSource": "CHIP",
        "dateOfBirthSourceName": "ReadID NFC",
        "dateOfExpiry": "YYMMDD",
        "dateOfExpirySource": "CHIP",
        "dateOfExpirySourceName": "ReadID NFC",
        "documentCode": "ID",
        "documentCodeSource": "CHIP",
        "documentCodeSourceName": "ReadID NFC",
        "documentNumber": "ABC000000",
        "documentNumberSource": "CHIP",
        "documentNumberSourceName": "ReadID NFC",
        "documentType": "I",
        "documentTypeSource": "CHIP",
        "documentTypeSourceName": "ReadID NFC",
        "gender": "MALE",
        "genderSource": "CHIP",
        "genderSourceName": "ReadID NFC",
        "issuingCountry": "US",
        "issuingCountrySource": "CHIP",
        "issuingCountrySourceName": "ReadID NFC",
        "nameOfHolder": "JOHN DOE",
        "nameOfHolderSource": "CHIP",
        "nameOfHolderSourceName": "ReadID NFC",
        "nationality": "US",
        "nationalitySource": "CHIP",
        "nationalitySourceName": "ReadID NFC",
        "personalNumber": "00000000X",
        "personalNumberSource": "CHIP",
        "personalNumberSourceName": "ReadID NFC",
        "placeOfBirth": null,
        "placeOfBirthSource": null,
        "placeOfBirthSourceName": null,
        "primaryIdentifier": "DOE",
        "primaryIdentifierSource": "CHIP",
        "primaryIdentifierSourceName": "ReadID NFC",
        "secondaryIdentifier": "JOHN",
        "secondaryIdentifierSource": "CHIP",
        "secondaryIdentifierSourceName": "ReadID NFC",
        "selfieVerificationProfile": null,
        "selfieVerificationProfileSource": null,
        "selfieVerificationProfileSourceName": null,
        "selfieVerificationStatus": null,
        "selfieVerificationStatusSource": null,
        "selfieVerificationStatusSourceName": null,
        "sessionId": "1d4ab816-f8b0-466d-8403-77f7692f7142",
        "version": 1,
        "visualVerification": null,
        "visualVerificationSource": null,
        "visualVerificationSourceName": null
    },
    "creationDate": "2020-03-18T07:59:27.111Z",
    "customerApplicationReference": "SUBMITTER-DEMO-JOHN",
    "deviceId": "0000000000000000",
    "deviceInfo": {
        "brand": "Xiaomi",
        "extendedLengthApduSupported": true,
        "manufacturer": "Xiaomi",
        "maxTransceiveLength": 65279,
        "model": "Mi 9T",
        "OSVersion": "10",
        "platform": "android",
        "timestamp": 1584518365815
    },
    "documentContent": {
        "@odata.type": "#nl.innovalor.mrtd.model.ICAODocumentContent",
        "datagroupNumbers": [1, 2, 3, 7, 11, 13, 14],
        "dateOfBirth": "YYMMDD",
        "dateOfExpiry": "YYMMDD",
        "dateOfIssue": null,
        "documentNumber": "ABC000000",
        "faceImages": [
        {
            "colorSpace": "UNSPECIFIED",
            "height": 378,
            "image": "https://ready.readid.com/odata/v1/Streams/1d4ab816-*****/faceImage/0",
            "mimeType": "image/jp2",
            "original": "https://ready.readid.com/odata/v1/Streams/1d4ab816-******/faceImage/0/original",
            "originalImageBytes": null,
            "source": "UNSPECIFIED",
            "width": 307
        }
        ],
        "fullDateOfBirth": "YYYY-MM-DDT00:00:00Z",
        "interpretedDateOfBirth": "DD.MM.YYYY",
        "interpretedDateOfExpiry": "DD.MM.YYYY",
        "interpretedIssuingCountry": "United States",
        "issuingAuthority": null,
        "issuingCountry": "US",
        "ldsVersion": "1.7",
        "nameOfHolder": "DOE, JOHN",
        "personalNumber": "00000000X",
        "primaryIdentifier": "DOE",
        "secondaryIdentifier": "JOHN",
        "signatureImages": [
        {
            "colorSpace": null,
            "height": 0,
            "image": "https://ready.readid.com/odata/v1/Streams/1d4ab816-******/signatureImage/0",
            "mimeType": "image/jpeg",
            "original": "https://ready.readid.com/odata/v1/Streams/1d4ab816-******/signatureImage/0/original",
            "source": null,
            "width": 0
        }
        ],
        "custodian": null,
        "documentCode": "ID",
        "gender": "MALE",
        "interpretedNationality": "American",
        "mrzPrimaryIdentifier": "DOE",
        "mrzSecondaryIdentifier": "JOHN",
        "MRZString": "****",
        "nationality": "US",
        "otherNames": [],
        "permanentAddress": ["Address", "City", "State/Province"],
        "placeOfBirth": "City, State",
        "placeOfBirthList": ["City", "State"],
        "profession": null,
        "telephone": null,
        "title": null,
        "unicodeVersion": "4.0.0"
    },
    "exceptions": [],
    "expiryDate": "YYYY-MM-DDT12:59:27.111Z",
    "instanceId": "651a06b0-1020-4f29-bd66-b13db272e79b",
    "iProovSession": {
        "attempts": null,
        "enrolmentPod": null,
        "enrolmentToken": null,
        "errorString": null,
        "finished": null,
        "hasError": null,
        "passed": null,
        "riskProfile": null,
        "verifyToken": []
    },
    "lib": {
        "coreVersion": "1.33.0",
        "mobileCountryCode": "us",
        "mrtdConfiguration": {
        "AAEnabled": true,
        "allowedFids": [],
        "BACByDefaultEnabled": true,
        "clientServerBaseURL": "https://ready.readid.com/odata/v1/ODataServlet/",
        "clientServerHttpRetries": 5,
        "clientServerHttpWaitPeriod": 30000,
        "CSCAKeyStoreTypeName": null,
        "debugModeEnabled": false,
        "documentType": "ICAO_MRTD",
        "DSCSEnabled": true,
        "EACCAEnabled": true,
        "extendedLengthAPDUEnabled": false,
        "extendedLengthMaxBufferBlockSize": 64000,
        "NFCForegroundDispatchMuteTime": 0,
        "NFCMinimalIsoDepTimeout": 30000,
        "NFCReaderModePresenceCheckDelay": 4200,
        "PACEEnabled": false,
        "timestamp": 1584518353107
        },
        "nfcVersion": "1.33.0",
        "ocrConfiguration": {
        "allowedSizes": ["3x30", "2x44", "2x36"],
        "defaultCorrectnessCriterionUsed": true,
        "diligence": 5,
        "focusMode": "continuous-picture",
        "scaleMode": "ASPECT_FIT",
        "timestamp": 1584518352994
        },
        "ocrVersion": "3.28.0",
        "timestamp": 1584518365819
    },
    "mitekSession": {
        "url": null
    },
    "mrzOCR": null,
    "NFC": null,
    "nfcSession": {
        "accessControlStatus": {
        "BAC": "PRESENT_SUCCEEDED",
        "BACReason": "SUCCEEDED",
        "EACTA": "UNKNOWN",
        "EACTAReason": "UNKNOWN",
        "PACE": "PRESENT_NOT_PERFORMED",
        "PACEReason": "PRESENCE_DETECTED"
        },
        "data": [],
        "documentType": "ICAO_MRTD",
        "features": ["BAC", "PACE", "EAC"],
        "verificationStatus": {
        "AA": "NOT_PRESENT",
        "AAReason": "NOT_SUPPORTED",
        "AAResult": null,
        "CAResult": {
            "encryptedResponseBytes": null,
            "keyId": null,
            "oid": "0.4.0.127.0.7.2.2.3.2.1",
            "pcdPrivateKeyBytes": null,
            "pcdPublicKeyBytes": null
        },
        "CS": "PRESENT_SUCCEEDED",
        "CSReason": "FOUND_A_CHAIN_SUCCEEDED",
        "DS": "PRESENT_SUCCEEDED",
        "DSReason": "SIGNATURE_CHECKED",
        "EACCA": "PRESENT_SUCCEEDED",
        "EACCAReason": "SUCCEEDED",
        "HT": "PRESENT_SUCCEEDED",
        "HTReason": "ALL_HASHES_MATCH"
        }
    },
    "ocrSession": {
        "mrz": "****",
        "mrzImage": {
        "height": 170,
        "mimeType": "image/png",
        "sha256Sum": "2gE+m/HkGTvc0wNDoYyEoqPu5KlAy1/rq47937sGsYw=",
        "width": 1117
        },
        "mrzType": "TD1"
    },
    "opaqueId": null,
    "readySession": {
        "opaqueId": "40170d6f-****",
        "readySessionId": "74ce5690-****"
    },
    "serverVersion": "1.57.10",
    "sessionId": "1d4ab816-****",
    "vizSession": {
        "backImage": {
        "height": 1280,
        "mimeType": "image/jpeg",
        "sha256Sum": "tIxHaippZYzguXDme58kXdXdUbl+dj08kTSNknEx6Gg=",
        "width": 960
        },
        "frontImage": null
    }
    }';
}
